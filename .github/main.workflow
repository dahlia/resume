workflow "Publish" {
  on = "push"
  resolves = ["trigger-gh-pages"]
}

action "build" {
  uses = "docker://ubuntu:19.10"
  runs = [
    "/bin/bash", "-c",
    "apt-get update -y && apt-get install -y --no-install-recommends pandoc build-essential python3-dev python3-pip python3-setuptools python3-wheel python3-cffi libcairo2 libpango-1.0-0 libpangocairo-1.0-0 libgdk-pixbuf2.0-0 libffi-dev shared-mime-info fonts-noto-cjk && pip3 install WeasyPrint==48 && make"
  ]
}

action "publish" {
  needs = ["build"]
  uses = "maxheld83/ghpages@v0.2.1"
  env = {
    BUILD_DIR = "public/"
  }
  secrets = [
    "GH_PAT"
  ]
}

action "trigger-gh-pages" {
  needs = ["publish"]
  uses = "actions/bin/curl@master"
  secrets = [
    "GH_PAT"
  ]
  args = [
    "-X", "POST",
    "-H", "'Authorization: token '$GH_PAT",
    "-H", "'Accept: application/vnd.github.mister-fantastic-preview+json'",
    "https://api.github.com/repos/$GITHUB_REPOSITORY/pages/builds"
  ]
}
