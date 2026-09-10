# ./lib/DarkPAN/Indexer.pm.in
./lib/DarkPAN/Indexer.pm: \
    ./lib/DarkPAN/Indexer/Role/Indexer.pm \
    ./lib/DarkPAN/Indexer/Role/Loader.pm

# ./lib/DarkPAN/Resolver/SQLite.pm.in
./lib/DarkPAN/Resolver/SQLite.pm: \
    ./lib/DarkPAN/Indexer/Role/Utils.pm

