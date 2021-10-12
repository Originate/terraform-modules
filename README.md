# terraform-modules

Composable Terraform modules for provisioning infrastructure stacks

## Automatic Releases

This repository is configured to publish releases automatically using
semantic-release when changes are merged to `main`. Releases are posted on
Github with automatically-generated changelogs. Here is what you need to know.

### Special commit message format

Automatic releases include automatically-generated changelogs. To make this work
it is important to write commit messages in the
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) format.
A CI action is included that will check that your PR title matches that format.
Make sure to "Squash & Merge" PRs to ensure that the PR title is used as the git
commit message for your change.

Briefly the first line of a commit message must begin with one of the prefixes,
`fix:`, `feat:`, `build:`, `chore:`, `ci:`, `docs:`, `style:`, `refactor:`,
`perf:`, `test:`

A commit message may include a "trailer" (a paragraph at the end of the message
preceded by a blank line) that begins with the string `BREAKING CHANGE:`

### When releases are triggered

On a merge to `main` a release is created if and only if a new feature, bug fix,
or breaking change has been introduced since the latest release. Whether one of
these has been introduced is determined by parsing specially-formatted commit
messages. If the first line of a commit begins with `feat:` that means the
change introduces a feature; `fix:` means the change includes a bug fix. Any
commit with a `BREAKING CHANGE:` trailer indicates a breaking change.

### How version numbers are calculated

The version number for a new release is based on the number of the latest
release, and the types of changes that have been made since that release.
According to the convention of semantic version numbering a bug fix causes the
patch number to be incremented, a feature increments the minor version number,
and a breaking change increments the major version number.

### Tracking major version numbers

When you source a module using Terraform you provide a "ref" to use. You can fix
your Terraform configuration to a specific release version number. But it might
be more convenient to get the latest release from a given major version. For
example,

```tf
module "cognito_agent_pool" {
  source = "github.com/Originate/terraform-modules//aws/cognito_user_pool?ref=v1"
                                                # Track the latest v1 release ^
}
```

The release workflow for this repository automatically updates the latest major
version branch to point to the latest release to make this possible. If
a breaking change is merged which causes a major version bump then the workflow
will automatically create a new major version branch, and leave the previous
major version branch pointing to the last release with the matching major
version.

### Publishing maintenance releases

Maybe the latest release is `v2.1.0`, but you want to publish a new `v1` release
with fixes for users tracking the `v1` branch. You can do this by merging
changes to the `v1` branch instead of to `main`.

Do not merge changes to a major version branch if it is the latest major version
branch! It is important to be able to fast-forward merge `main` into the latest
major version branch.

Do not merge breaking changes into a major version branch. If you do semantic
release will refuse to create a release, and you will have to rewrite the
history of that branch to remove the breaking change to get releases working
again.

### Updating semantic-release settings

Settings are in `.releaserc.yml`. You probably won't need to change this; but
there it is in any case.
