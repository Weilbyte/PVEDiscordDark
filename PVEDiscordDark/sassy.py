# Script to compile SASS to CSS
# Requires libsass and watchdog pip packages
#
# Input: PVEDiscordDark.sass
# Output: PVEDiscordDark.css (compressed, no sourcemap)
#
# Passing 'w' or 'watch' as argument to the script will auto-compile on every SASS change

import time
import os
import sys

try:
    import sass
    from watchdog.observers import Observer
    from watchdog.events import PatternMatchingEventHandler
except ImportError:
    print("FATAL: libsass or watchdog package not installed but required")
    exit(1)

self_location = os.path.dirname(os.path.realpath(__file__))
sass_src_name = "PVEDiscordDark.sass"
sass_src_path = os.path.join(self_location, "sass", sass_src_name)
sass_out_path = os.path.splitext(sass_src_path)[0] + ".css"
sass_out_last_generated = 0

def compile():
    global sass_out_last_generated
    if time.time() - sass_out_last_generated < 0.5:
        return
    with open(sass_out_path, "w") as f:
        try: 
            f.write(sass.compile(filename=sass_src_path, output_style="compressed"))
            print(f"Compiled {sass_src_name} to {os.path.basename(sass_out_path)}")
        except sass.CompileError as e:
            print(f"ERROR: {e}")
        sass_out_last_generated = time.time()

if __name__ == "__main__":
    if not os.path.exists(sass_src_path):
        print(f"FATAL: SASS source file ({sass_src_name}) not found")
        exit(1)

    should_watch = len(sys.argv) > 1 and (sys.argv[1] == "w" or sys.argv[1] == "w")

    compile()
    if should_watch:
        handler = PatternMatchingEventHandler(["*.sass"])
        handler.on_modified = lambda event: compile()
        observer = Observer()
        observer.schedule(handler, os.path.dirname(sass_src_path), recursive=True)
        observer.start()
        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            observer.stop()
            observer.join()