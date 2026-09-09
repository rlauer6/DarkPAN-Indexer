# Table of Contents

* [NAME](#name)
* [SYNOPSIS](#synopsis)
* [DESCRIPTION](#description)
* [OPTIONS](#options)
# NAME

DarkPAN::Indexer - Build a module index from an S3-backed DarkPAN

# SYNOPSIS

    darkpan-indexer \
      --bucket my-darkpan \
      --output modules.tsv

    darkpan-indexer \
      --bucket my-darkpan \
      --prefix orepan2/authors/id/ \
      --region us-east-1 \
      --output modules.tsv

    darkpan-indexer load \
      --bucket cpan.openbedrock.net \
      --input modules.tsv

# DESCRIPTION

`DarkPAN::Indexer` scans the `authors/id/` hierarchy of an S3-backed
DarkPAN for CPAN distribution tarballs.

Each `.tar.gz` distribution is downloaded, examined with
[Dist::Metadata](https://metacpan.org/pod/Dist%3A%3AMetadata), and immediately written to a tab-separated flat file.

Each output record contains:

    distribution-tarball<TAB>module-name<TAB>module-version

For example:

    Amazon-API-2.8.0.tar.gz    Amazon::API             2.8.0
    Amazon-API-2.8.0.tar.gz    Amazon::API::Bedrock    2.8.0

If a module does not declare a version, the distribution version is used.

All distribution versions encountered in the DarkPAN are retained.

The `load` command creates a new SQLite database from an index file.
The database filename is derived from the bucket name by replacing dots
with hyphens and appending `.db`. An existing database is backed up
before the new database is created.

# OPTIONS

- **--bucket**, **-b**

    S3 bucket containing the DarkPAN.

- **--input**, **-i**

    Input TSV file used by the `load` command.

- **--output**, **-o**

    Output TSV file used by the `index` command.

- **--prefix**, **-p**

    S3 prefix containing the DarkPAN authors hierarchy.

    Defaults to:

        authors/id/

- **--region**, **-r**

    AWS region containing the S3 bucket.

    Defaults to:

        us-east-1

- **--help**, **-h**

    Display usage information.
