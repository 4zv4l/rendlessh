#!/usr/bin/env raku

unit sub MAIN(
    Str  :$addr        = '0.0.0.0', #= Bind to this address
    UInt :$port        = 2222,      #= Bind to this port
    UInt :$delay       = 10,        #= Delay in seconds between each write
    UInt :$max-clients = 50,        #= Max amount of client at the same time
);

my atomicint $active = 0;
react {
    whenever IO::Socket::Async.listen($addr, $port) -> $conn {
        my $start = now;
        my $addr  = (try $conn.peer-host // '?') ~ ':' ~ (try $conn.peer-port // '?');
        
        note "[WARN] Dropped $addr (at capacity $max-clients)" and $conn.close and next if $active >= $max-clients;
        note "[INFO] New Victim on $addr ({++⚛$active}/$max-clients)";
        
        my $writer = Supply.interval($delay).tap: { $conn.print: (^2**64).pick.base(16) ~ "\r\n" }
        my &clean  = { $conn.close; $writer.close; --⚛$active };
        
        whenever $conn.Supply {
            LAST { note "[INFO] Victim released after {(now - $start).fmt('%.2f')}s ({$active}/$max-clients)"; &clean() }
            QUIT { default { say "[ERR]  $addr: {.message} after {(now - $start).fmt('%.2f')}s"; &clean() }}
        }
    }
    whenever signal(SIGINT) { say "\rBye !"; exit }
    note "[INFO] Listening on $addr:$port";
}
