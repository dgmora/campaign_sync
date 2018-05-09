# CampaignSync

This is a solution for the ruby task for HeyJobs. The description stated
that a Rails app should not be used. A database is needed though.

I decided to use a gem (unpublished) as it's a common and simple way to pack
ruby code. For the database I've used `ActiveRecord`

## Notes

- Apologies for having just one real commit, I usually do more.
- I assumed that Campaigns that exist remotely but not locally are 'lost',
not in state `deleted`
- The database part is quite similar to Rails, it's what I know and what
I thought it was simpler to have a database.
- I commented quite a lot `service.rb`. I think that it's better than doing
very tiny methods that seem self-explanatory (but they aren't), specially
when there are subtle cases that might be missed.
- Having different names locally, remotely and also in the diff made me go
back and forth in the implementation a bit.
- I saw the gem [HashDiff](https://github.com/liufengyun/hashdiff) but I thought
using it and saying "that's the format I want" wasn't a real solution 
:slightly_smiling_face:

## Installation

The gem is not published, so you need to install it locally:

```ruby
rake install
```
## Usage

The gem uses sqlite3 as database. A populated database
is already included (`syncer` file), but you can re-seed it with:

```
campaign_sync seed
```

To show the discrepancies just do:

```
campaign_sync
```

To test do:

```
bundle exec rspec
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
