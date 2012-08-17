# snap

Snap is an IRC bot written using [cinchrb/cinch](https://github.com/cinchrb/cinch). This code powers a bot currently running in the #reddit-portland channel on `irc.freenode.net`. However, this repository is clonable and runnable using your own configuration options.

## Requirements

* Ruby
* bundler
* Redis

## Usage

To run the bot:

```bash
Usage:
  bot start -n, --nick=NICK

Options:
  -n, --nick=NICK                 
  -s, [--server=SERVER]           
                                  # Default: irc.freenode.net
  -c, [--channels=\#freenode \#cinch-bots]  
  -u, [--username=USERNAME]       
  -p, [--password=PASSWORD]       
      [--redis-host=REDIS_HOST]   
                                  # Default: localhost
      [--redis-port=N]            
                                  # Default: 6379
  -d, [--daemonize]               
```

To stop a daemonized bot:

```bash
Usage:
  bot stop
```

Certain commands respond only to admins (such as `!join`, `!part`, and `!say`). To define your list of admins, create a file `config/auth.yml`:

```yaml
admins: ['davidcelis', 'fredjones']
```
