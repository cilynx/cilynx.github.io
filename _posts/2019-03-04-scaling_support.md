---
layout: post
title:  Scaling Support
date:   2019-03-04 11:45:55 -0800
tags:   
---
## Background

What I'm about to describe is by no means comprehensive or the only way to scale a Support organization.  Rather, it is a stream of consciousness collection of inflection point methodologies that I've seen work first hand.

## In the beginning...

In my experience, startups tend to begin with developers, sales folks, and the C-suite doing Support over email.  Once the workload gets high enough for an FTE, they tend to hire one person to both work day-to-day with customers and develop the long term Support program / product.

One of the most interesting challenges at this phase is weening customers off of C-suite attention and onto `support@`.  This is where titles like Director of Customer Support come in handy even if the title-holder is the only person in the department and spends most of their time answering tickets.

As the new Support Director getting customers acclimated to a single endpoint, you should also be evaluating ticket systems.  I'll not go down that rabbit hole in this post, but you'll want something in place before you make your first hire.

## Getting a few hires

As the overall business grows you'll get to the point that there's more work than you can do on your own and you need to start building a team.  At this stage, you're looking for a dedicated heads-down support engineers -- a generalist who enjoys troubleshooting and is a solid communicator.  You'll still be working tickets, but it will be easier on you and your customers in the future if your first hire is in a similar timezone to your own.

Your second hire should be another generalist, but instead of trying to match your timezone this time, try to match the bulk of your customer contacts who are not in your timezone.  We want to start maximizing coverage as soon as reasonably possible.

As you look towards your third hire, start thinking about what the eventual organization is going to look like.  Do you want team leads?  Will you have a premium offering?  Does your product break down into verticals?  This next hire should be someone who is comfortable working tickets today, but who you expect to grow into leadership role in whatever subdivision makes the most sense to do first in your organization.

## Contact Reduction

One of the best things you can do to drive down Support load is to help customers help themselves.  At this stage of startup, it's reasonable for Support to own a public-facing FAQ and KB and the content and the workflow should look something like this:

* Any question that comes to Support repeatedly needs a canned response
* Any canned response that is used regularly needs a FAQ/KB article
* If the same question is still coming in product needs to:
   * First link to the FAQ/KB at the appropriate place in the product
   * Then fix the awkward workflow with something that doesn't confuse customers

## The Support Product

Around this time, you want to start thinking about what your Support product line is.  Do you want to profit from Support or is it a cost center?  Do you have tiers?  What sort of service levels can you commit to?  What do your customers need?

I've found that early in the Support product lifecycle, it makes sense to have three offerings:

|Offering|SLO|Cost|
|-|-|-|
|Basic|Best Effort|Included with product|
|Plus|8x5 1-day first response|Inexpensive|
|Premium|24x7 1-hour first response|Very expensive|

In addition to your other responsibilities, you are personally going to be the after-hours coverage for anyone on the Premium tier, so you want it to be cost prohibitive.  If you get substantial adoption anyway, you'll have the run-rate to justify headcount.

## Bootstrapping Premium

Assuming you get Premium adoption, you want to start that suborg quickly so it can adapt to your critical early strategic customers without you having to micromanage it.  This is a good place to task your third hire.  While the first two engineers are handling the Basic and Plus caseload, you and your third hire should work Premium tickets while you're hire develops the Premium program with your assistance.

You'll want to stay directly involved in hiring until the Premium organization has a handfull of TAMs and Enterprise Engineers who have been around a while.  At that point, you can pull back and let the leader your hired run with it.

## Simple Metrics

As a Support organization, your primary responsibility is to make your customers happy.  This can be measured and guestimated in many ways, including NPS, MTTR, and FCR.  I've not found a magic bullet and I believe every young (and perhaps not-so-young) Support organization needs to review all of these metrics and compare them with a gut-check by the folks working directly with the customers.  This will tell you which metrics best correlate with your customer happiness.

## Tiers and Verticals

Depending on your product and number of customers, you may need to scale your team into tiers and verticals.  This means hiring specialists and sorting out leads.  The most effective Support organization I've seen was broken down into three standard tiers and one *ops* tier:
* Tier 1: Front-line -- provides howto, links to docs, routes to other teams
* Tier 2: Primary escalation -- the first troubleshooters, generally mid-level engineers, well equipped to explain how things should work, share scripts, walk customers though complex use cases
* Tier 3: Vertical escalation -- these engineers are experts in their vertical and are brought in for advanced troubleshooting, architecture discussions, and scripting
* Tier 4: Ops escalation -- these folks sit with engineering and are often on career track to join the engineering team.  They have commit access to their product.  Ops escalation is brought in when the product is not working as advertised or to help strategic customers coerce the product to do things it was not designed to do.

You can generally expect one lead to work with a dozen or so engineers in a single tier and you should do an operational sync with all of the leads until the team scales enough that you need to hire/promote a manager for that side of the house.

## Complex Metrics & Customer Success

As you go further down the road, you're going to want as much insight into your customers as you can get.  This generally comes in the form of instrumentation in the product itself and analytics on the data stream.  This starts overflowing the realm of support, but you can get into all kinds of fun stuff here like:
* What user workflows lead to the most support cases? (What can we change in the product to reduce contacts?)
* What workflows do successful customers have? (What can we encourage new customers to do to ensure their success?)
* What workflows lead to turnover? (Do we need to change the product or guide customers to use it differently?)

This could be a very long post on its own, but I'm just going to leave it here for now.

## Positive Attrition

It may not be politically correct to come out and say it, but lots of folks use Support as a foot in the door to then move to other roles within a company.  I've seen employers try to stop this in different ways ranging from screening hard in interviews to having new hires sign a 2-year commitment that they'll stay in the org.

Personally, I'm fine with positive attrition and actually consider it a success for my organization.  It means that the folks I'm hiring and grooming are of the caliber that engineering wants to steal them away.  Further, as Support engineers move into dev and/or ops positions, the network of product engineers who understand and have experience with VoC.

To keep attrition (even positive) numbers reasonable, I firmly believe that all you have to do is make working in Support interesting and distinctly not terrible.  This is generally accomplished through a combination of long-term projects, appropriate skill/work alignment, sane coverage/rotation management, genuine appreciation for your employees as people, and getting out of the way so folks can do their jobs.

In my experience, I saw annual positive attrition of ~10% and greatly appreciated having solid contacts inside of the various engineering, product, architecture, and sales orgs folks moved to.
