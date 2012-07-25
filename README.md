# This is still work in progress, but will be released as a gem soon

# Spreewald

Spreewald is a collection of useful steps for cucumber. Feel free to fork.

## Installation

Add this line to your application's Gemfile:

    gem 'spreewald'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spreewald

## Usage

Steps are grouped into a number of categories. You can pick and choose single categories by putting something like
    require 'spreewald/email_steps'
into your `support/env.rb`

Alternatively, you can require everything by doing
    require 'spreewald/all_steps'

## Steps

For a complete list of steps you have to take a look at the step definitions themselves. This is just a rough overview.

### [email_steps](/makandra/spreewald/blob/master/lib/spreewald/email_steps.rb)

Check for the existance of an email with

    Then an email should have been sent with:
        """
        From: max.mustermann@example.com
        To: john.doe@example.com
        Subject: Unter anderem der Betreff kann auch "Anführungszeichen" enthalten
        Body: ...
        Attachments: ...
        """

You can obviously skip lines.

After you have used that step, you can also check for content with

    And that mail should have the following lines in the body:
      """
      Jede dieser Text-Zeilen
      muss irgendwo im Body vorhanden sein
      """

### [table_steps](/makandra/spreewald/blob/master/lib/spreewald/table_steps.rb)

Check the content of tables in your HTML.

See [this article](https://makandracards.com/makandra/763-cucumber-step-to-match-table-rows-with-capybara) for details.


### [timecop_steps](/makandra/spreewald/blob/master/lib/spreewald/timecop_steps.rb)

Steps to travel through time using [Timecop](https://github.com/jtrupiano/timecop).

See [this article](https://makandracards.com/makandra/1222-useful-cucumber-steps-to-travel-through-time-with-timecop) for details.

### [util_steps](/makandra/spreewald/blob/master/lib/spreewald/util_steps.rb)

Some utility steps and transforms. Supports

* `Then debugger`
* `Then it should work`       (marks step as pending)
* `@slow-motion` (waits 2 seconds after each step)
* `@single-step` (waits for keyboard input after each step)

### [web_steps](/makandra/spreewald/blob/master/lib/spreewald/web_steps.rb)

Most of cucumber-rails' original websteps plus some of our own.

Note that cucumber-rails deprecated those a while ago (you can see the original deprecation notice at the top of [our web_steps](/makandra/spreewald/blob/master/lib/spreewald/web_steps.rb)). Make up your own mind whether you want to use them or not.
