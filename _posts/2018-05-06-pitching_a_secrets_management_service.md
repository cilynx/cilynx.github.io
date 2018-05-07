---
layout: post
title:  Pitching a Secrets Management Service
date:   2018-05-06 08:44:23 -0700
tags:   
---
*I was recently asked how to pitch an internal secrets management service to a company that doesn't have one.  As this was an unpaid request, I am providing the fruit of my efforts here in the hope that my fellow travelers find it useful.  That said, I provide no guarantee or warranty as to the accuracy or usefulness of the information contained herein for any purpose.*

## The Problem

As companies move more and more of their operations to interconnected systems, many challenges arise around identification and authentication for access to various data and services.  Traditional access control mechanisms involve a publicly known component (usernames, public keys, etc) and a secret (passwords, private keys, etc).  These mechanisms move the problem from id/authn to management of the secrets.

In the simplest cases, users memorize passwords.  This mechanism quickly breaks down due to [fundamentally flawed yet still enforced ideals around what a strong password is](https://xkcd.com/936/) as well as limitations on human memory and even the basic assumption that there is always going to be a human in the system in the first place.

## Requirements

The natural solution is a Secrets Management Service.  This service must meet several requirements:
* Secrets (passwords, keys, certificates, etc) must be stored securely
* Secrets must be able to be created, read, updated, deleted, and verified
* Secrets must be versioned / lifecycled
* All operations must be accessible only to authenticated and authorized entities (human or otherwise)
* Granular permissions must support both individual and role-based access controls
* All operations must be recorded in a tamper resistant / evident audit trail
* All operations must be accessible through an easy-to-use API
* The service must be ACID compliant and highly-available

## Build vs. Buy

Now, of course in 2018, we're not the first ones to identify the need for this type of service.  Many very intelligent and capable folks have created secrets management services and several are available on the public market, some as commercial products and others as open source projects.  To appropriately evaluate the marketplace options and compare procurement, integration, and development efforts along with direct costs, the company should assemble the smallest possible task force which includes representation from:

|Who|Why|
|-|-|
| Security Development / Engineering | Owns developing tools that are not bought or acquired as open source |
| Security Operations / DevOps | Owns operating the Secrets Management Service and integrating with existing systems |
| Product / Platform Engineering | Primary consumer of the Secrets Management Service |
| Procurement / Finance | Owns the business and legal processes around acquiring commercial or open source software |

The decision of which pre-existing product or project (or none at all) to base the new service upon should not be taken lightly.  It is well worth some extra time and effort upfront to perform proof-of-value with several potential solutions and compare their ease of deployment, integration, use, maintenance, etc. under real-world conditions with each other as well as the efforts required and advantages to develop a personally tailored solution in-house.

A non-exhaustive list of commercially available Secrets Management Services:
* [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/)
* [Azure Key Vault](https://azure.microsoft.com/en-us/services/key-vault/)
* [Google Cloud KMS](https://cloud.google.com/kms/docs/secret-management)
* [HashiCorp Vault Enterprise](https://www.hashicorp.com/products/vault)
* [CyberArk Conjur Enterprise](https://www.cyberark.com/products/privileged-account-security-solution/cyberark-conjur/)

A non-exhaustive list of open source Secrets Management Services:
* [HashiCorp Vault](https://www.vaultproject.io/) ([github](https://github.com/hashicorp/vault))
* [Nike Cerberus](https://engineering.nike.com/cerberus/) ([github](https://github.com/Nike-Inc))
* [Pinterest Knox](https://github.com/pinterest/knox/wiki) ([github](https://github.com/pinterest/knox))
* [CyberArk Conjur](https://www.conjur.org/) ([github](https://github.com/cyberark/conjur/))
* [Square Keywhiz](https://square.github.io/keywhiz/) ([github](https://github.com/square/keywhiz))
* [Lyft Confidant](https://lyft.github.io/confidant/) ([github](https://github.com/lyft/confidant/))

## Deliverables

<table>
<thead>
<th>Phase</th>
<th>Deliverables</th>
</thead>
<tbody>
<tr>
<td>Potential Base Product Selection</td>
<td><ul><li>A short list of commercial and open source solutions to run through PoV</li><li>A well-defined timeline and resource requirements breakdown for each PoV</li><li>A detailed requirements document / checklist to enable quantitative comparison</li></ul></td>
</tr><tr>
<td>Proof of Value</td>
<td><ul><li>Limited deployment and integration of each potential solution, modeling as much of production workload as possible</li><li>Scored requirements documents for each tested solution</li><li>A decision of which solution to move forward with</li></ul></td>
</tr><tr>
<td>Initial Production</td><td><ul><li>Development of any missing pieces (or the whole thing) to meet the requirements defined above</li><li>Deployment and integration with one production system</li><li>Feedback from the initial consumer</li><li>Self-audit by the Security Team to ensure all requirements are met in production</li><li>Initial evangelical collateral</li></ul></td>
</tr><tr>
<td>Iteration</td><td><ul><li>Serial (or at least not massively parallel) deployment and integration with remaining production programs</li><li>Continued feedback from all live consumers</li></ul></td>
</tr><tr>
<td>Codification / Evangelism</td><td><ul><li>Training, policy, enforcement, and audit mechanisms to ensure all future engineering stores secrets in the Secret Management Service unless there is a deliberate and documented business reason not to</li><li>Continuous feedback review from all consumers to ensure the service is providing continued value and not being used only because policy says so</li></ul></td>
</tr>
</tbody>
</table>

## Success Criteria

I break project success down into three categories:

<table>
<thead>
<th>Criteria</th>
<th>Details</th>
<th>The Path</th>
</thead>
<tbody>
<tr>
<td>Voluntary Adoption</td>
<td><ul><li>In the Iteration phase, future consumers are asking how soon they can onboard</li><li>Existing consumers are providing feedback and suggestions</li><li>No one is "working the system" to avoid using the service</li><li>Very few consumers are using the service only because it is policy to do so</li></ul></td>
<td><ul><li>Displaying immediate value by solving problems future consumers have today</li><li>Providing unobtrusive, quick feedback mechanisms</li><li>Avoiding sacrificing one use-case to serve another</li><li>Positioning the service as an efficiency aid first and security improvement second</li></ul></td>
</tr><tr>
<td>Makes Things Better</td>
<td><ul><li>Secrets are stored more securely than before</li><li>Secrets are easier to manage, so engineers develop simpler, more secure, and more maintainable applications in less time</li></ul></td>
<td><ul><li>Encryption at rest and in flight, RBAC, audit trail, etc.</li><li>Logical, standards compliant, easy-to-use API</li></ul></td>
</tr><tr>
<td>Doesn't Make Things Worse</td>
<td><ul><li>Minimizes new attack surfaces</li><li>Minimizes operational overhead</li><li>Does not cause confusion or frustration with developers or users</li></ul></td>
<td><ul><li>RBAC, least privilege, well-defined arena where secrets live and where they do not</li><li>Logical, modern deployment and upgrade framework -- containerization, red/blue, etc. depending on existing processes</li><li>Logical, standards compliant, easy-to-use API and purposely designed and A/B tested UX</li></ul></td>
</tr>
</tbody>
</table>

## Logistics / Expenses

*This section is very company-specific, so I'm only able to provide some high-level guidance.*

<table>
<thead>
<th>Phase</th>
<th>Logistics / Expenses</th>
</thead>
<tbody>
<tr>
<td>Potential Base Product Selection</td>
<td><ul><li><em>This phase requires time commitment primarily from the task force discussed above. Their deliverables could be achieved through independent research with followup presentation and discussion of findings or potentially one or two substantial group research sessions.</em></li></ul></td>
</tr><tr>
<td>Proof of Value</td>
<td><ul><li><em>This phase requires substantial time commitment from the task force as well as future service consumers and integration resources.  Depending on the size of the Security and Product/Project Management Teams, these PoVs could be done serially or parallel.  There are advantages to parallel PoV as you can compare things side-by-side, but it also increases complexity and thrash in the project, which could lead to poorer decisions.</em></li></ul></td>
</tr><tr>
<td>Initial Production</td><td><ul><li><em>This phase requires time commitment from the Security Team, the initial consumers, and potentially procurement to secure any outside software that will be used.  This phase is the inflection point where concepts become reality, so all resources directly engaged in delivery should have little else on their dockets.  This phase is also where software costs become a reality if a commercial solution is chosen as the base.</em></li></ul></td>
</tr><tr>
<td>Iteration</td><td><ul><li><em>This phase requires time commitment from the Security Team, the onboarding consumers, and the existing consumers (as consultants to the new).  Onboarding should be more efficient than the previous phase and become even more efficient with each additional consumer onboarded.  If basing on a commercial SaaS, software costs will increase as consumers are added.</em></li></ul></td>
</tr><tr>
<td>Codification / Evangelism</td><td><ul><li><em>This phase requires time commitment from the Security Team, Compliance, Training, and Tech Writing as this is where the point-in-time state is transformed into business as usual.  As this phase involves more integration with existing process and procedure than project-specific work, I would expect the resources working in the phase to be multi-tasking more than those in other phases.</em></li></ul></td>
</tr>
</tbody>
</table>

## Bibliography
*...aka: stuff other than the inline links that I watched and read while putting together this post*
* [Project Proposal Writing: How to Write a Winning Project Proposal](https://www.youtube.com/watch?v=jsGBuu88WE0)
* [PoC vs PoV - What's the difference Mr. Software Vendor?](https://www.linkedin.com/pulse/poc-vs-pov-whats-difference-mr-software-vendor-andrew-brockfield/)
