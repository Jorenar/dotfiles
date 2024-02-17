import os

GRIPHOME = os.environ.get("GRIPHOME", os.path.join(os.environ["HOME"], ".grip"))
GRIPURL = os.environ.get("GRIPURL", "/__/grip")

CACHE_DIRECTORY = os.path.join(os.environ["XDG_CACHE_HOME"], "grip")
os.makedirs(CACHE_DIRECTORY, exist_ok=True)

try:
    os.symlink(os.path.join(GRIPHOME, "tweaks.css"),
               os.path.join(CACHE_DIRECTORY, "tweaks.css"))
except:
    pass

STYLE_URLS = [ os.path.join(GRIPURL, "asset", "tweaks.css") ]
