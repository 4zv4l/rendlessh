# rendlessh
Endlessh in Raku

## usage

```
Usage:
  ./endlessh.raku [--addr=<Str>] [--port[=UInt]] [--delay[=UInt]] [--max-clients[=UInt]]
  
    --addr=<Str>            Bind to this address [default: '0.0.0.0']
    --port[=UInt]           Bind to this port [default: 2222]
    --delay[=UInt]          Delay in seconds between each write [default: 10]
    --max-clients[=UInt]    Max amount of client at the same time [default: 50]
```

## run

Simply `raku endlessh.raku`.
