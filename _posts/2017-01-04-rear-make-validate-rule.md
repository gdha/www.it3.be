---
layout: post
title: ReaR make validate rule in the Makefile
description:
tags: [terminal, rear, relax-and-recover, Linux, script, bash, support, tutorial, howto, it3 consultants]
author: gratien
---

<strong>Relax-and-recover (ReaR) make validate rule in the Makefile</strong>

Relax-and-recover (ReaR) will have a new release (v2.00) before end of January 2017 (just before FOSDEM 2017) and one of the major changes was the renumbering of our script names from `xx_script.sh` into `xxx_script.sh` (where x represents a numeric).

We should point out that end-users adding there own scripts into the ReaR tree must be aware of this! However, we introduced some extra checks in the *validate* rule of the `Makefile` to automatically check the script names (which should start with 3 numerics).

The following is the validate rule within the `makefile` :

    validate:
            @echo -e "\033[1m== Validating scripts and configuration ==\033[0;0m"
            find etc/ usr/share/rear/conf/ -name '*.conf' | xargs -n 1 bash -n
            bash -n $(rearbin)
            find . -name '*.sh' | xargs -n 1 bash -n
            find usr/share/rear -name '*.sh' | grep -v -E '(lib|skel|conf)' | while read FILE ; do \
                    num=$$(echo $${FILE##*/} | cut -c1-3); \
                    if [[ "$$num" = "000" || "$$num" = "999" ]] ; then \
                            echo "ERROR: script $$FILE may not start with $$num"; \
                            exit 1; \
                    else \
                            if $$( grep '[_[:alpha:]]' <<< $$num >/dev/null 2>&1 ) ; then \
                                      echo "ERROR: script $$FILE must start with 3 digits"; \
                                      exit 1; \
                            fi; \
                    fi; \
           done

What was added the _while_ loop which does the 3 numeric check of the script names. Please notice that we skip all directories that contain the keywords *lib*, *skel* and *conf*.
Let it work:

    $ make validate
    == Validating scripts and configuration ==
    find etc/ usr/share/rear/conf/ -name '*.conf' | xargs -n 1 bash -n
    bash -n usr/sbin/rear
    find . -name '*.sh' | xargs -n 1 bash -n
    find usr/share/rear -name '*.sh' | grep -v -E '(lib|skel|conf)' | while read FILE ; do \
	num=$(echo ${FILE##*/} | cut -c1-3); \
	if [[ "$num" = "000" || "$num" = "999" ]] ; then \
		echo "ERROR: script $FILE may not start with $num"; \
		exit 1; \
	else \
		if $( grep '[_[:alpha:]]' <<< $num >/dev/null 2>&1 ) ; then \
			echo "ERROR: script $FILE must start with 3 digits"; \
			exit 1; \
		fi; \
	fi; \
    done
    $

No output means all scripts were starting with 3 digits.
To test it we introduce a script starting with 2 digits.

    $ touch usr/share/rear/prep/default/22_faulty.sh
    $ make validate
    == Validating scripts and configuration ==
    find etc/ usr/share/rear/conf/ -name '*.conf' | xargs -n 1 bash -n
    bash -n usr/sbin/rear
    find . -name '*.sh' | xargs -n 1 bash -n
    find usr/share/rear -name '*.sh' | grep -v -E '(lib|skel|conf)' | while read FILE ; do \
	num=$(echo ${FILE##*/} | cut -c1-3); \
	if [[ "$num" = "000" || "$num" = "999" ]] ; then \
		echo "ERROR: script $FILE may not start with $num"; \
		exit 1; \
	else \
		if $( grep '[_[:alpha:]]' <<< $num >/dev/null 2>&1 ) ; then \
			echo "ERROR: script $FILE must start with 3 digits"; \
			exit 1; \
		fi; \
	fi; \
    done
    ERROR: script usr/share/rear/prep/default/22_faulty.sh must start with 3 digits
    make: *** [validate] Error 1
    $ rm -f usr/share/rear/prep/default/22_faulty.sh
    

References:

* [Relax-and-Recover Release Notes 2.00](http://relax-and-recover.org/documentation/release-notes-2-00)
