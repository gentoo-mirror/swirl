# swirl repo
ebuilds for the `swirl` Gentoo repo. These are for applications I use that aren't present in Gentoo repositories, or for my own stuff.

# Adding the Repository

## `eselect-repository`

```bash
# install eselect-repository if needed
emerge --ask --noreplace eselect-repository

# enable overlay
eselect repository enable swirl
```

### Manual

```bash
# add the repo to repos.conf
cat << EOF > /etc/portage/repos.conf/swirl.conf
[swirl]
location = /var/db/repos/swirl
sync-type = git
sync-uri = https://github.com/binex-dsk/ebuilds
EOF
```

## Syncing
Do this after either of the previous options.
```bash
emaint sync --repo swirl
```

# Notes
passman++ and libpassman require Qt 6, which currently has not been merged to the Gentoo Qt project upstream (see [gentoo/qt#224](https://github.com/gentoo/qt/pull/224)).

All packages are marked with the `~amd64` keyword, so to install packages, the desired version must be unmasked--see the portage manpage for this.
