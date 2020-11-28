---
layout: post
title: Publish docs via GitHub Pages fails with 'TypeError- expected str, bytes or os.PathLike object, not NoneType'

description: Publish docs via GitHub Pages fails with "TypeError- expected str, bytes or os.PathLike object, not NoneType"

tags: [mkdocs, GitHub Pages, GitHub Actions, it3 consultants]
author: gratien
---

<strong>Publish docs via GitHub Pages fails with \"TypeError: expected str, bytes or os.PathLike object, not NoneType\"</strong>

The [Relax-and-Recover User Guide](https://github.com/rear/rear-user-guide) was using GitHub Actions to build automatically web pages via GitHub Pages via the following workflow:
```bash
name: Publish docs via GitHub Pages
on:
  push:
    branches:
      - main

jobs:
  build:
    name: Deploy docs
    runs-on: ubuntu-latest
    steps:
      - name: Checkout main
        uses: actions/checkout@v1

      - name: Deploy MkDocs
        uses: mhausenblas/mkdocs-deploy-gh-pages@master
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          PUBLISH_BRANCH: gh-pages
```

The above workflow worked fine for a while but since mid October 2020 the automatic build failed with the following error - albeit a manual `mkdocs gh-deploy` still worked.

```bash
Run mhausenblas/mkdocs-deploy-gh-pages@master
  env:
    pythonLocation: /opt/hostedtoolcache/Python/3.8.6/x64
    LD_LIBRARY_PATH: /opt/hostedtoolcache/Python/3.8.6/x64/lib
    GITHUB_TOKEN: ***
    PUBLISH_BRANCH: gh-pages
/usr/bin/docker run --name bfefaa979694806bf2891d3c29b85bd_f0e5a8 --label 179394 --workdir /github/workspace --rm -e pythonLocation -e LD_LIBRARY_PATH -e GITHUB_TOKEN -e PUBLISH_BRANCH -e HOME -e GITHUB_JOB -e GITHUB_REF -e GITHUB_SHA -e GITHUB_REPOSITORY -e GITHUB_REPOSITORY_OWNER -e GITHUB_RUN_ID -e GITHUB_RUN_NUMBER -e GITHUB_RETENTION_DAYS -e GITHUB_ACTOR -e GITHUB_WORKFLOW -e GITHUB_HEAD_REF -e GITHUB_BASE_REF -e GITHUB_EVENT_NAME -e GITHUB_SERVER_URL -e GITHUB_API_URL -e GITHUB_GRAPHQL_URL -e GITHUB_WORKSPACE -e GITHUB_ACTION -e GITHUB_EVENT_PATH -e GITHUB_ACTION_REPOSITORY -e GITHUB_ACTION_REF -e GITHUB_PATH -e GITHUB_ENV -e RUNNER_OS -e RUNNER_TOOL_CACHE -e RUNNER_TEMP -e RUNNER_WORKSPACE -e ACTIONS_RUNTIME_URL -e ACTIONS_RUNTIME_TOKEN -e ACTIONS_CACHE_URL -e GITHUB_ACTIONS=true -e CI=true -v "/var/run/docker.sock":"/var/run/docker.sock" -v "/home/runner/work/_temp/_github_home":"/github/home" -v "/home/runner/work/_temp/_github_workflow":"/github/workflow" -v "/home/runner/work/_temp/_runner_file_commands":"/github/file_commands" -v "/home/runner/work/rear-user-guide/rear-user-guide":"/github/workspace" 179394:2bfefaa979694806bf2891d3c29b85bd
WARNING: The directory '/github/home/.cache/pip' or its parent directory is not owned or is not writable by the current user. The cache has been disabled. Check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
Requirement already satisfied: mkdocs in /usr/local/lib/python3.8/site-packages (from -r /github/workspace/requirements.txt (line 1)) (1.1.2)
Collecting mkdocs-ivory
  Downloading mkdocs_ivory-0.4.6-py3-none-any.whl (10 kB)
Requirement already satisfied: mkdocs-redirects in /usr/local/lib/python3.8/site-packages (from -r /github/workspace/requirements.txt (line 3)) (1.0.1)
Collecting markdown-fenced-code-tabs
  Downloading markdown_fenced_code_tabs-1.0.5-py3-none-any.whl (9.2 kB)
Collecting mkdocs-rtd-dropdown
  Downloading mkdocs-rtd-dropdown-1.0.2.tar.gz (248 kB)
Requirement already satisfied: PyYAML>=3.10 in /usr/local/lib/python3.8/site-packages (from mkdocs->-r /github/workspace/requirements.txt (line 1)) (5.3.1)
Requirement already satisfied: lunr[languages]==0.5.8 in /usr/local/lib/python3.8/site-packages (from mkdocs->-r /github/workspace/requirements.txt (line 1)) (0.5.8)
Requirement already satisfied: tornado>=5.0 in /usr/local/lib/python3.8/site-packages (from mkdocs->-r /github/workspace/requirements.txt (line 1)) (6.1)
Requirement already satisfied: Markdown>=3.2.1 in /usr/local/lib/python3.8/site-packages (from mkdocs->-r /github/workspace/requirements.txt (line 1)) (3.3.3)
Requirement already satisfied: Jinja2>=2.10.1 in /usr/local/lib/python3.8/site-packages (from mkdocs->-r /github/workspace/requirements.txt (line 1)) (2.11.2)
Requirement already satisfied: livereload>=2.5.1 in /usr/local/lib/python3.8/site-packages (from mkdocs->-r /github/workspace/requirements.txt (line 1)) (2.6.3)
Requirement already satisfied: click>=3.3 in /usr/local/lib/python3.8/site-packages (from mkdocs->-r /github/workspace/requirements.txt (line 1)) (7.1.2)
Requirement already satisfied: htmlmin>=0.1.12 in /usr/local/lib/python3.8/site-packages (from markdown-fenced-code-tabs->-r /github/workspace/requirements.txt (line 4)) (0.1.12)
Requirement already satisfied: six>=1.11.0 in /usr/local/lib/python3.8/site-packages (from lunr[languages]==0.5.8->mkdocs->-r /github/workspace/requirements.txt (line 1)) (1.15.0)
Requirement already satisfied: future>=0.16.0 in /usr/local/lib/python3.8/site-packages (from lunr[languages]==0.5.8->mkdocs->-r /github/workspace/requirements.txt (line 1)) (0.18.2)
Requirement already satisfied: nltk>=3.2.5; python_version > "2.7" and extra == "languages" in /usr/local/lib/python3.8/site-packages (from lunr[languages]==0.5.8->mkdocs->-r /github/workspace/requirements.txt (line 1)) (3.5)
Requirement already satisfied: MarkupSafe>=0.23 in /usr/local/lib/python3.8/site-packages (from Jinja2>=2.10.1->mkdocs->-r /github/workspace/requirements.txt (line 1)) (1.1.1)
Requirement already satisfied: tqdm in /usr/local/lib/python3.8/site-packages (from nltk>=3.2.5; python_version > "2.7" and extra == "languages"->lunr[languages]==0.5.8->mkdocs->-r /github/workspace/requirements.txt (line 1)) (4.53.0)
Requirement already satisfied: joblib in /usr/local/lib/python3.8/site-packages (from nltk>=3.2.5; python_version > "2.7" and extra == "languages"->lunr[languages]==0.5.8->mkdocs->-r /github/workspace/requirements.txt (line 1)) (0.17.0)
Requirement already satisfied: regex in /usr/local/lib/python3.8/site-packages (from nltk>=3.2.5; python_version > "2.7" and extra == "languages"->lunr[languages]==0.5.8->mkdocs->-r /github/workspace/requirements.txt (line 1)) (2020.11.13)
Building wheels for collected packages: mkdocs-rtd-dropdown
  Building wheel for mkdocs-rtd-dropdown (setup.py): started
  Building wheel for mkdocs-rtd-dropdown (setup.py): finished with status 'done'
  Created wheel for mkdocs-rtd-dropdown: filename=mkdocs_rtd_dropdown-1.0.2-py3-none-any.whl size=249242 sha256=a63b8139e4e5e2af9a48db32a60bdeba149176a39dee2cbf00dd0938681cd75e
  Stored in directory: /tmp/pip-ephem-wheel-cache-lngt3bf_/wheels/c6/5d/af/cda61f5e7ce1580dac018c7c4840226bcc65b2a8ea5a4673c3
Successfully built mkdocs-rtd-dropdown
Installing collected packages: mkdocs-ivory, markdown-fenced-code-tabs, mkdocs-rtd-dropdown
Successfully installed markdown-fenced-code-tabs-1.0.5 mkdocs-ivory-0.4.6 mkdocs-rtd-dropdown-1.0.2
WARNING: You are using pip version 20.0.2; however, version 20.2.4 is available.
You should consider upgrading via the '/usr/local/bin/python -m pip install --upgrade pip' command.
INFO: setup with GITHUB_TOKEN
Traceback (most recent call last):
  File "/usr/local/bin/mkdocs", line 8, in <module>
    sys.exit(cli())
  File "/usr/local/lib/python3.8/site-packages/click/core.py", line 829, in __call__
    return self.main(*args, **kwargs)
  File "/usr/local/lib/python3.8/site-packages/click/core.py", line 782, in main
    rv = self.invoke(ctx)
  File "/usr/local/lib/python3.8/site-packages/click/core.py", line 1259, in invoke
    return _process_result(sub_ctx.command.invoke(sub_ctx))
  File "/usr/local/lib/python3.8/site-packages/click/core.py", line 1066, in invoke
    return ctx.invoke(self.callback, **ctx.params)
  File "/usr/local/lib/python3.8/site-packages/click/core.py", line 610, in invoke
    return callback(*args, **kwargs)
  File "/usr/local/lib/python3.8/site-packages/mkdocs/__main__.py", line 171, in gh_deploy_command
    cfg = config.load_config(
  File "/usr/local/lib/python3.8/site-packages/mkdocs/config/base.py", line 197, in load_config
    errors, warnings = cfg.validate()
  File "/usr/local/lib/python3.8/site-packages/mkdocs/config/base.py", line 115, in validate
    post_failed, post_warnings = self._post_validate()
  File "/usr/local/lib/python3.8/site-packages/mkdocs/config/base.py", line 95, in _post_validate
    config_option.post_validation(self, key_name=key)
  File "/usr/local/lib/python3.8/site-packages/mkdocs/config/config_options.py", line 469, in post_validation
    config[key_name] = theme.Theme(**theme_config)
  File "/usr/local/lib/python3.8/site-packages/mkdocs/theme.py", line 45, in __init__
    self._load_theme_config(name)
  File "/usr/local/lib/python3.8/site-packages/mkdocs/theme.py", line 75, in _load_theme_config
    theme_dir = utils.get_theme_dir(name)
  File "/usr/local/lib/python3.8/site-packages/mkdocs/utils/__init__.py", line 297, in get_theme_dir
    return os.path.dirname(os.path.abspath(theme.load().__file__))
  File "/usr/local/lib/python3.8/posixpath.py", line 374, in abspath
    path = os.fspath(path)
TypeError: expected str, bytes or os.PathLike object, not NoneType
```

After doing some research on the internet we came across an interesting page [Deploying Mkdocs via Github Actions](https://bluegenes.github.io/mkdocs-github-actions/) which also described how to setup automatic builds via GitHub Pages, but with a different workflow.

After modifying the workflow to the following it was working again:

```bash
name: build and deploy mkdocs to github pages
on:
  push:
    branches:
      - master
jobs:
  deploy:
    runs-on: ubuntu-18.04
    steps:
      - uses: actions/checkout@v2
        with:
          submodules: "recursive" 
          fetch-depth: 0       # Fetch all history for .GitInfo and .Lastmod
      - name: Setup Python
        uses: actions/setup-python@v1
        with:
          python-version: '3.8'
          architecture: 'x64'
      - name: Install dependencies
        run: |
          python3 -m pip install --upgrade pip     # install pip
          python3 -m pip install mkdocs            # install mkdocs 
          python3 -m pip install mkdocs-material   # install material theme
          python3 -m pip install mkdocs-redirects  # install mkdocs-redirects
          python3 -m pip install markdown-fenced-code-tabs
          python3 -m pip install mkdocs-rtd-dropdown
      - name: Build site
        run: mkdocs build
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: $\{\{ secrets.GITHUB_TOKEN }}
          publish_dir: ./site
```

Be aware, that in [above workflow](https://github.com/rear/rear-user-guide/blob/master/.github/workflows/main.yml) the github_token contains backslashes, but in reality these may not be there (just needed them to display the secret environment variable).

### References:

[1] [Relax-and-Recover User Guide](https://github.com/rear/rear-user-guide)

[2] [Deploying Mkdocs via Github Actions](https://bluegenes.github.io/mkdocs-github-actions/)

[3] [GitHub Actions for GitHub Pages](https://github.com/peaceiris/actions-gh-pages)

[4] [GitHub Actions workflow of the ReaR User Guide](https://github.com/rear/rear-user-guide/blob/master/.github/workflows/main.yml)

### Edit history

- initial post on 28 November 2020
