---
layout: post
title:  Evangelizing for Security
date:   2018-05-07 07:31:56 -0700
tags:   
---
*In an similar vein to [Pitching a Secrets Management Service]({% post_url 2018-05-06-pitching_a_secrets_management_service %}), I was recently asked how to evangelize security within an engineering organization.  This is a very deep topic and I'll only be providing a high-level overview in this post.  Still, I hope it proves useful.  As before, I provide no guarantee or warranty as to the accuracy or usefulness of the information contained herein for any purpose.*

## The Problem

Security has been an accepted part of product engineering for some time;   however, it is often seen as a gateway or hurdle -- something developers and product managers deal with begrudgingly like paying taxes.  This mindset often leads to engineers and product owners doing the bare minimum requirements or even looking for loopholes in order to maintain their application performance, availability, delivery timeline, etc.

## Making Things Better

I propose that working with product and engineering teams around security requires a two-pronged approach.  One side is *Compliance* and the other is *Enablement*.

### Compliance

Compliance as a concept has gained substantial traction over the last decade or so -- though to some extent there is still some fuzzyness around what it means.  To merchants, it can mean PCI.  To hospitals it can mean HIPAA.  To anyone performing business on the world stage, it can mean SOC2 or ISO270001 or any of the myriad other compliance standards out in the market today.  To others yet, it may mean working to a set of internal standards defined by the organization.  That said, I want to take a step back and look at *compliance* as a concept rather than any specific implementation there-of.

Merriam-Webster [defines compliance](https://www.merriam-webster.com/dictionary/compliance) as:
* 1: a: *the act or process of complying to a desire, demand, proposal or regimen or to coercion*  
&nbsp;&nbsp;&nbsp;&nbsp;b: *conformity in fulfilling official requirements*
* 2: *a disposition to yield to others*
* 3: *the ability of an object to yield elastically when a force is applied*

The overarching concept is that compliance involves doing things you might not otherwise do in response to external pressure.  Not a very cheery picture, eh?  It doesn't have to be all doom and gloom though.  Many of today's compliance standards were developed with and by the very communities they govern.  They encompass best practices that have been tested and proven to work.

To sell compliance internally, you need to educate your organization around a few topics:
* What compliance standards are you beholden to and why?
* Who developed those standards and how are they kept current and relevant?
* What are the benefits of validating your compliance and the repercussions of not doing so?
* Which standards are you as a company already in-line with and which are works-in-progress?
* What actually needs to be done to effect compliance?
* How does compliance validation help position your company as compared to your competitors?
* What value does your compliance bring to your customers?

In order to reach all of the stakeholders and participants, I believe that these questions need to be answered both in writing (CBT, intranet, etc) and verbally (30-60 minute talk at a company all-hands by the company's compliance lead with support from business and engineering leadership).

### Enablement

In my experience, enablement is a side of security that fewer people look at, but I believe it has the potential to have just as much positive impact as compliance.  The basic idea is to reverse the "the security team is an obstacle we must negotiate" mentality and change that to "the security team enables us to work faster with less frustration".

One good approach is to follow the platform services model.  AWS and all of the other cloud vendors are working up the stack beyond IaaS now simply because the model works.  If you provide developers with high-level legos, they can get more done in less time with less frustration.

To use the example of our [Secrets Management Service]({% post_url 2018-05-06-pitching_a_secrets_management_service %}), without the service, developers have to find a way to deal with secrets within their applications.  This means thinking about encryption and storage, lifecycles, attack vectors, business continuity, audit validation, and everything else that comes along with directly handling sensitive data.  With a managed service available, they just write that portion of their application to the API and leave all of the running around to the specialists.

Enablement is generally pretty straightforward to sell internally, but here are some bullets to get you started:
* What services do the security team offer that can make development more straightforward and efficient?
* Which internal programs have already adopted internal security services and what impact are they seeing on moral and productivity?
* How does the security team receive and act on feedback around new and existing services?

As with compliance, to appeal to a varied audience, these questions should be answered both in writing and interactively.  The written portion should be a service catalog with well-documented APIs including example usage.  The verbal portion should be a 30-60 minute talk by someone high-level in the security team with knowledge of all of the services.  A "guest speaker" from one of the engineering teams that has already found value can really help to resonate your message with other teams.

## Resources

* [What is API Documentation, and Why it Matters](https://swaggerhub.com/blog/api-documentation/what-is-api-documentation-and-why-it-matters/)
* [PCI Security Standards Council](https://www.pcisecuritystandards.org/pci_security/)
* [HIPAA for Professionals](https://www.hhs.gov/hipaa/for-professionals/)
* [ISO/IEC 27000 - Information Security Management Systems](https://www.iso.org/isoiec-27001-information-security.html)
