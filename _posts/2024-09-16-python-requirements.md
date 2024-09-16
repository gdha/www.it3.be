---
layout: post
title: How to create a requirements.txt file of your python project?

description: How to create a requirements.txt file of your python project

tags: [Open Source, python, it3 consultants, requirements.txt ]
author: gratien
---

<strong>How to create a requirements.txt file of your python project?</strong>

To get all installed modules or packages is by going to your virtual environment directory
on the terminal and run the command:

```bash
pip3 freeze > requirements.txt
```

Another method, is by installing `pipreqs` package, e.g. `pip3 install pipreqs`

Then, it is as easy as:

```bash
cd $HOME/project/to/your/python/project
pipreqs .
```

As a result a `requirements.txt` file will be created in your python project directory.

