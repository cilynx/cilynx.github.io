---
layout: post
title:  Playing with stocks
date:   2018-06-01 08:20:52 -0700
tags:   finance
---

## Oh good, more useless stock picks

A better title for this post might be "everyone else is doing it".  Everyone and their mom picks stocks.  Some get lucky, others don't.  I'm playing around with some quantitative models and dabbling in backtesting.  Like most of my  posts, my goal here is to bring some transparency to a generally murky landscape.

## Disclaimer

This post is for entertainment purposes only.  Don't do anything based on this post.  I am neither licensed nor the slightest bit qualified to give financial advice.  Everything in this post is incredibly naïve.  I am not responsible for anything _you_ do with _your_ money.

I am not being compensated to write this post.  I may have long positions in some of the stocks mentioned herein.

## Methodology

I'm not interested in high-frequency, day, or swing trading.  I'm exceptionally lazy, so I'm only interested in buy-and-hold.

I started out by collecting the last 20-years or so of [OHLC](https://en.wikipedia.org/wiki/Open-high-low-close_chart) data for the entire stock market into a SQLite database.  (There are myriad software packages designed around pick/trade strategy, testing, and execution, but I like being decades behind the times and doing it myself.)

The first algorithm I'm playing with follows the idea of quality momentum over time.  My initial trials are using a 5-year term, however a longer term may be beneficial in order to incorporate resilience to severe market downturns such as the one in 2008.

## The Algorithm

_More Disclaimers: I'm not claiming to have invented this algorithm.  Most likely, there are books written about it and why it doesn't actually work.  I will continue to believe that the best way to learn anything is doing it yourself.  Thank you._

`Growth` = Most Recent Close / First Close in Term

`Max Drop` = The largest percentage drop the stock has seen from any local maxima

`Score` = `Growth` * (1 - `Max Drop`)^`n`

The higher `n` is, the more detrimental any drops are to the score.  Thus, higher `n` biases the algorithm towards stocks that don't drop very much.  Of course, as you go higher, you lose out on more and more high-growth stocks.  For the time being, I'm using `n=3`, but I'm not committed to that in the long haul.

In the future, I want to play around with standard deviation instead of just maximum drop to gauge the impact of one-time or potentially periodic-but-not-smooth growth events.

Another flaw of the algorithm is that due to the growth calculation, it biases towards stocks that were very low at the beginning of the term.  I'm not honestly sure if that's a good or a bad thing, but it's something I want to investigate further in future posts.

## Top Ten
5-year term, `n=3`

|Symbol|Description|Exchange|Industry|Sector|Score|Growth|Max Drop|
|-|
|TAL|	TAL Education Group |	NYSE |	Other Consumer Services |	Consumer Services |	8.34565119521 |	23.6059376216 |	0.292901919812|
|NVDA |	NVIDIA Corporation |	NASDAQ |	Semiconductors |	Technology |	7.5825370384 |	18.4822279223 |	0.256946519271|
|MGPI |	MGP Ingredients, Inc. |	NASDAQ |	Beverages (Production/Distribution) |	Consumer Non-Durables |	6.66409557197 |	17.1385991058 |	0.270113553999|
|ABMD |	ABIOMED, Inc. |	NASDAQ |	Medical/Dental Instruments| 	Health Care |	4.54595938176 |	17.6781076067 |	0.364088626421|
|IDXX |	IDEXX Laboratories, Inc. 	|NASDAQ |	Biotechnology: In Vitro & In Vivo Diagnostic Substances |	Health Care |	4.15657405286 |	10.0974781765 |	0.25611203418|
|FB |	Facebook, Inc. |	NASDAQ 	|Computer Software: Programming, Data Processing |	Technology |	3.64326854665 |	7.87597535934 |	0.226615236258|
|ERI |	Eldorado Resorts, Inc.| 	NASDAQ 	|Hotels/Resorts |	Consumer Services |	3.54329529253 |	11.9893899204 |	0.333904109589|
|PRMW |	Primo Water Corporation |	NASDAQ |	Food Distributors |	Consumer Non-Durables |	3.28471058388 |	10.1676646707 |	0.313840155945|
|NOVT |	Novanta Inc. |	NASDAQ |	Industrial Machinery/Components |	Capital Goods |	3.25993057339 |	7.96683046683 |	0.257594936709|
|CCF |	Chase Corporation |	AMEX 	|Building Products |	Consumer Durables |	2.97763579391 |	6.42139926582 |	0.225988700565|

## Now what?

I'm planning to post on the 1st of each month, showing the performance of the portfolio with and without monthly rebalancing.

Between now and July, I'm looking to do a writeup on backtesting to give some perspective through data.
