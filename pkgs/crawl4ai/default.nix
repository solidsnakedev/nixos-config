{
  lib,
  python3,
  fetchFromGitHub,
  playwright-driver,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "crawl4ai";
  version = "0.8.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unclecode";
    repo = "crawl4ai";
    rev = "v${version}";
    hash = "sha256-cE5eF5nw9K6coYDE+xm2JKicmoMiAs1Jf7sQfsuAWcA=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  postPatch = ''
    # Remove directory creation from setup.py that assumes writable HOME
    sed -i '/# Create the .crawl4ai folder/,/^    (crawl4ai_folder \/ folder).mkdir(exist_ok=True)/d' setup.py
  '';

  dependencies = with python3.pkgs; [
    aiofiles
    aiohttp
    aiosqlite
    anyio
    lxml
    litellm
    numpy
    pillow
    playwright
    python-dotenv
    requests
    beautifulsoup4
    xxhash
    rank-bm25
    snowballstemmer
    pydantic
    pyopenssl
    psutil
    pyyaml
    nltk
    rich
    cssselect
    httpx
    fake-useragent
    click
    chardet
    brotli
    humanize
    lark
    shapely
  ];

  pythonRemoveDeps = [
    "patchright"
    "tf-playwright-stealth"
    "alphashape"
    "unclecode-litellm"    # upstream fork, not in nixpkgs; litellm is already a dep
    "playwright-stealth"   # not in nixpkgs
  ];

  pythonRelaxDeps = [
    "lxml"
    "snowballstemmer"
    "pyOpenSSL"
  ];

  makeWrapperArgs = [
    "--set PLAYWRIGHT_BROWSERS_PATH ${playwright-driver.browsers}"
    "--set PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD 1"
  ];

  doCheck = false;

  meta = {
    description = "Open-source LLM-friendly web crawler & scraper";
    homepage = "https://github.com/unclecode/crawl4ai";
    license = lib.licenses.asl20;
    mainProgram = "crwl";
    platforms = lib.platforms.all;
  };
}
