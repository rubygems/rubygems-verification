This directory contains scripts used by me (raggi) during the incident. Some of
them were modified throughout the process, others were cp'd and then modified.

Two major phases are seen here, the first was the secondary validation of Marks
work to grep the s3 gem files for additional cases of the metadata exploit. You
will see code in `validate_from_url.sh` that was doing this. Our results were
the same. The second phase was for sha generation, and some scripts changed
patterns slightly in order to do this, in particular they stopped putting each
gem in a subdirectory.

Most of the hashing results can be found in the top level directory of the repo.

Rubyforge validations are excluded due to their lack of usefulness, and no
scripts were involved in the sync (just rsync).

Some additional commands were used in repairing data sets after bad downloads
(particularly for the tk and tao sets). These commands were of the form:

```
(((cat ../unverified.gemnames; ls) | sort | uniq -d); cat ../unverified.gemnames) |sort | uniq -u | xargs -P 10 -I % -n 1 wget -q -c http://ruby.taobao.org/gems/%
```

The `file(1)` usage may be curious to readers. This was to filter out downloads
that were pulling 503 response HTMLs. There are probably better ways, but this
was workable.

Due to confidentiality concerns, scripts used to generate the `google_3rd` and
`google_ghost` hash sets are not included, and additional details will only be
made available if absolutely necessary (and later authorized by Google).

I would like to personally thank a few other folks who may or may not be listed
elsewhere:

 * bbgCormac and foul_owl from Blue Box. They were both patient and very
   helpful.
 * bradland for putting together documents during the incident, and being a
   communication hub.
 * stevenhaddox, who ensured I saw the message about the taobao.org mirror, and
   quark_zju for originally pointing that out, and the owner (whoever they are)
   for letting us pull data from it.
