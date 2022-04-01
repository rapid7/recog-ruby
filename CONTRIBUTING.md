# Contributing to Recog-Ruby

The users and maintainers of Recog-Ruby would greatly appreciate any contributions
you can make to the project.  These contributions typically come in the form of
filed bugs/issues or pull requests (PRs).  These contributions routinely result
in new versions of the [recog gem](https://rubygems.org/gems/recog) being
released.  The process for everything is described below.

## Table of Contents

1. [Contributing Issues / Bug Reports](#contributing-issues-/-bug-reports)
1. [Contributing Code](#contributing-code)
    1. [Fork and Clone](#fork-and-clone)
    1. [Branch and Improve](#branch-and-improve)
    1. [Testing](#testing)
1. [Project Operations](#project-operations)
    1. [Landing PRs](#landing-prs)
    1. [Releasing New Versions](#releasing-new-versions)

## Contributing Issues / Bug Reports

If you encounter any bugs or problems with Recog-Ruby, please file them
[here](https://github.com/rapid7/recog-ruby/issues/new), providing as much detail as
possible.  If the bug is straight-forward enough and you understand the fix for
the bug well enough, you may take the simpler, less-paperwork route and simply
fill a PR with the fix and the necessary details.

[^back to top](#contributing-to-recog-ruby)

## Contributing Code

Recog-Ruby uses a model nearly identical to that of
[Metasploit](https://github.com/rapid7/metasploit-framework) as outlined
[here](https://github.com/rapid7/metasploit-framework/wiki/Setting-Up-a-Metasploit-Development-Environment),
at least from a ```git``` perspective.  If you've been through that process
(or, even better, you've been through it many times with many people), you can
do exactly what you did for Metasploit but with Recog-Ruby and ignore the rest of
this document.

On the other hand, if you haven't, read on!

[^back to top](#contributing-to-recog-ruby)

### Fork and Clone

Generally, this should only need to be done once, or if you need to start over.

1. Fork Recog-Ruby: Visit https://github.com/rapid7/recog-ruby and click Fork,
   selecting your github account if prompted
1. Clone `git@github.com:<your-github-username>/recog-ruby.git`, replacing
`<your-github-username>` with, you guessed it, your Github username.

    ```bash
    git clone --recurse-submodules git@github.com:<your-github-username>/recog-ruby.git
    ```
    * If you cloned the project and forgot `--recurse-submodules`, you may run the following command to initialize, fetch and checkout any nested submodules.

        ```bash
        git submodule update --init --recursive
        ```

1. Add the Rapid7 recog-ruby repository as your upstream:

    ```bash
    git remote add upstream git@github.com:rapid7/recog-ruby.git
    ```

1. Update your `.git/config` to ensure that the `remote ["upstream"]` section is configured to pull both branches and PRs from upstream.  It should look something like the following, in particular the second `fetch` option:

    ```bash
     [remote "upstream"]
      url = git@github.com:rapid7/recog-ruby.git
      fetch = +refs/heads/*:refs/remotes/upstream/*
      fetch = +refs/pull/*/head:refs/remotes/upstream/pr/*
    ```

1. Fetch the latest revisions, including PRs:

    ```bash
    git fetch --all
    ```

[^back to top](#contributing-to-recog-ruby)

### Branch and Improve

If you have a contribution to make, first create a branch to contain your
work.  The name is yours to choose, however generally it should roughly
describe what you are doing.  In this example, and from here on out, the
branch will be FOO, but you should obviously change this:

```bash
git fetch --all
git checkout main
git rebase upstream/main
git checkout -b FOO
```

Now, make your changes, commit as necessary with useful commit messages.

Please note that changes to [lib/recog/version.rb](lib/recog/version.rb) in PRs are almost never necessary.

Now push your changes to your fork:

```bash
git push origin FOO
```

Finally, submit the PR.  Navigate to ```https://github.com/<your-github-username>/recog-ruby/compare/FOO```, fill in the details and submit.

[^back to top](#contributing-to-recog-ruby)

### Testing

When your PR is submitted, it will be automatically subjected to the full run of tests in the [CI workflow](.github/workflows/ci.yml), however you are encourage to perform testing _before_ submitting the PR.  To do this, simply run `rake tests`.

[^back to top](#contributing-to-recog-ruby)

## Project Operations

### Landing PRs

(Note: this portion is a work-in-progress.  Please update it as things change)

Much like with the process of submitting PRs, Recog-Ruby's process for landing PRs
is very similar to [Metasploit's process for landing
PRs](https://github.com/rapid7/metasploit-framework/wiki/Landing-Pull-Requests).
In short:

1. Follow the "Fork and Clone" steps from above
2. Update your `.git/config` to ensure that the `remote ["upstream"]` section is configured to pull both branches and PRs from upstream.  It should look something like the following, in particular the second `fetch` option:

    ```bash
     [remote "upstream"]
      url = git@github.com:rapid7/recog-ruby.git
      fetch = +refs/heads/*:refs/remotes/upstream/*
      fetch = +refs/pull/*/head:refs/remotes/upstream/pr/*
    ```

3. Fetch the latest revisions, including PRs:

    ```bash
    git fetch --all
    ```

4. Checkout and branch the PR for testing.  Replace ```PR``` below with the actual PR # in question:

    ```bash
    git checkout -b landing-PR upstream/pr/PR
    ```

5. Test the PR (see the Testing section above)
6. Merge with main, re-test, validate and push:

    ```bash
    git checkout -b upstream-main --track upstream/main
    git merge -S --no-ff --edit landing-PR # merge the PR into upstream-main

    # re-test if/as necessary
    git push upstream upstream-main:main --dry-run # confirm you are pushing what you expect

    git push upstream upstream-main:main # push upstream-main to upstream:main
    ```

7. If applicable, release a new version (see next section)

[^back to top](#contributing-to-recog-ruby)

### Releasing New Versions

When Recog-Ruby's critical parts are modified, for example its fingerprints or underlying supporting code, a new version _must_ eventually be released.  These new releases can then be optionally included in projects such as Metasploit or products such as Rapid7's Nexpose in a controlled manner.  Releases for non-functional updates such as updates to documentation are not necessary.

When a new version of Recog-Ruby is to be released, you _must_ follow the instructions below.

1. If are not already a Recog-Ruby project contributor for the Recog gem (you'd be listed [here under OWNERS](https://rubygems.org/gems/recog)), become one:
   1. Get an account on [Rubygems](https://rubygems.org)
   1. Contact one of the Recog-Ruby project contributors (listed [here under OWNERS](https://rubygems.org/gems/recog) and have them add you to the Recog gem.  They'll need to run: `gem owner recog -a EMAIL`

1. Edit [lib/recog/version.rb](lib/recog/version.rb) and increment `VERSION`.  Commit and push to the rapid7/recog-ruby main branch.

1. Run `rake release`.  Among other things, this creates the new gem, uploads it to Rubygems and tags the release with a tag like `v<VERSION>`, where `<VERSION>` is replaced with the version from `version.rb`.  For example, if you release version 1.2.3 of the gem, the tag will be `v1.2.3`.

1. If your default remote repository is not `rapid7/recog-ruby`, you must ensure that the tags created in the previous step are also pushed to the right location(s).  For example, if `origin` is your fork of recog and `upstream` is `rapid7/main`, you should run `git push --tags --dry-run upstream` to confirm what tags will be pushed and then `git push --tags upstream` to push the tags.

[^back to top](#contributing-to-recog-ruby)
