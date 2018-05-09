# CampaignSync

This is a solution for the ruby task for HeyJobs. The description stated
that a Rails app should not be used. A database is needed though.

I decided to use a gem (unpublished) as it's a common and simple way to pack
ruby code. For the database I've given a try to [sequel](https://github.com/jeremyevans/sequel)

## Installation

The gem is not published, so you need to install it locally:

```ruby
rake install
```

## Usage

The gem uses sqlite3 as inmemory database. A populated database
is already included in a file, but you can re-seed it with:

```
campaign_sync seed
```

To show the discrepancies just do:

```
campaign_sync
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
