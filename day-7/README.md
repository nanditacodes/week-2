Day 7
====================================

Install Stuff
--------------

More info about Pry [REPL Driven Development](http://www.confreaks.com/videos/2864-rubyconf2013-repl-driven-development-with-pry)

Install pry (from terminal, run: )

```bash
gem install pry
```

Pry
----------------
to use pry:

```ruby
list.each do |item|
  binding.pry
  item.something
end
```

Homework:

* implement when you press r, it will move to the right
* implement when you press t, it will move to the top
* implement when you press l, it will move to the left

If possible, diagnose why it's never quitting the loop (optional / hard)


* Continue the DASH course (3rd section)
