=======================
Nim Tutorial (Part IV)
=======================

:Author: Ray Imber 
:Version: |nimversion|

.. contents::


Introduction
============

  "I decided long ago to stick to what I know best. Other people understand parallel machines much better than I do; programmers should listen to them, not me, for guidance on how to deal with simultaneity." -- Donald Knuth, professor emeritus at Stanford.

This document is a tutorial about how to use the *concurrency* features of Nim.

Note: This is about *concurreny* not *paralleism*, a related but different concept.
This document will briefly try to explain the difference in the appendix.

What is Blocking Code
---------------------

Async and Await
---------------

Nim provides a powerful and easy to use set of tools for writing concurrent programs through
the concept of *async* and *await*. You may be familiar with these concepts from languages such
as javascript, C#, or Python 3.6.

The *await* keyword tells the program to pause the current proc until 
an *async* proc is complete.

Note: *await* will pause *just the current function*.
   Unike blocking code, which pauses your whole program, 
   this just pauses the single function, 
   and allows a different function to run while it's waiting.
   This is the key to concurrent programming!

Futures
-------

You typically won't need to create ``Future`` objects yourself.
The ``async`` pragma should do it for you, but it is still important to understand
``Future`` objects for debugging and understanding the type signatures of ``async`` procs.

A ``Future`` is known in the Javascript world as a *promise*.
It is an object that holds the result of an async function that may not be complete yet.

All ``async`` functions return a ``Future`` object.

The ``await`` keyword tells your program to pause this proc until a ``Future`` is complete.
The ``Future`` object is how ``await`` knows when to wake up your proc again.

The ``Future`` object is a generic that holds the type of what the result will eventually be
when the ``async`` proc completes. If an ``async`` proc does not wish to return anything,
it will have a return type of ``Future[void]``.

Note: You can create ``Future`` objects manually. This is similar to creating a promise manually in
Javascript. It generally not recommended unless you have a very good reason.

The Async Runtime Loop
----------------------

This situation may be familiar to you:

You wrote a set of async functions in your Nim program.
The program compiled with no errors or warnings, but when you run the program, nothing happens!

The Async pattern requires an *event loop* that checks to see if events are ready 
and drives the async functions forward.
Other languages that you may be used to, such as Javascript or C#, embed this
event loop in the runtime and hide it from you.

In Nim, you have to start the event loop explicitly in your code! It is not automatic.

* You either start the event loop yourself at the start of your program or in your main proc.
  - To do this simply call: ``runForever()`` from the asyncdispatch module. 

  * Or you are using a library that starts an event loop for you
    (such as with the httpbeast or jester modules from Dom96)

Note: Generally, there should only ever be a single event loop running at any one time.

This has advantages and disadvantages:

Advantages:
* You have complete control over the event loop.
* You can use the normal pattern of starting a master event loop at the start of your program.
* Or, You can choose to loop until a single Future completes.
   - This is done with ``waitFor()`` from the asyncdispatch module.
   - This allows you to combine async and non-async code in complex ways.
* You can create your own event loop that can be started and stopped however you see fit
  - This is done by calling ``poll()`` from the asyncdispatch module directly
  - Note: This is a highly advanced technique.
    It is not recommended unless you know what you are doing.

Disadvantages:

* You must remember to explicitly start the event loop in your code, either directly
  or by calling the appropriate initialization method of a library.
* Generally, You must ensure that two event loops aren't running at the same time.
  - This can happen if you import two different modules that both have async code.

Waiting for Multiple Async Tasks
--------------------------------
# and and or from asyncdispatch
# use Araqs dowloading urls example

Debugging Async Code
--------------------
Exceptions
discarding
-d:futureLogging and getFuturesInProgress
Dom's Prometheous package

Threads
-------
 Use the hacky technique to poll the thread.
 Use read stdin exmample from Nim in Action book.
 Async Thread communication will get better once Channels get better TM.

Async in the Standard Library
-----------------------------
asyncdispatch
asyncfile
asyncstreams
asyncnet
httpclient
asynchttpserver
asyncftpclient
asyncjs

Async in External Libraries
---------------------------
httpbeast
Jester
What to do if you want to use a library that blocks and doesn't support async?
Ask the maintainer
If the library has a long poll proc:
 the *hacky async wrapper* technique of using a timer and long polling.
Last resort - run the blocking code in a seperate thread
 Use the hacky technique from above to poll the thread.
 May be the only option for some C/C++ libraries.

Making Your Nimble Library Async Compatible
-------------------------------------------
If you use blocking apis, if possible, try to use async equivalents instead.
It is common to provide both a simple synchronous verson and an async version of an api.
If you have your own event loop, make sure to explicitly document it!

Implemenation Notes
-------------------

The beauty of Nim is that async and await were able to be added to the language as a library 
using only the Macro system (see tutorial III)! 

Appendix and Futher Notes
=========================

Concurrency vs Parallelism
--------------------------

These two concepts are commonly confused. 
The problems they solve look similar on the surface,
but they are different design patterns that solve different problems.

Concurrency is commonly achieved with Async and parallelism is commonly achieved with Threads.

* Threads: Literally running two different pieces of code in parallel at the same time, on two physically different CPU cores.
* Async: A design pattern that lets a **single** CPU core continue to do work without having to wait for slow things like network connections or hard drive I/O to finish (known as *blocking*).

An example of where you would use threads: "I need to sort a large array, so I am going have a bunch of cores each sort a small piece of that array, all at the same time, so it finishes faster."

An example of Async is: "I need to read this file. Instead of putting the whole thread to sleep to wait for the hard drive to give me the file, I'm going to pass off control to another function to do some work, then just wake me up when the file is ready."

These two techniques compliment each other and can be used together.
A web browser is a good example of this: 

* You could have an async GUI thread that handles your button clicks, typing, and other user input... This is all async code that responds to user input events.
* Then you have a different thread that is doing complicated parsing (CSS and HTML) and rendering the final image.

Finding Help
------------
Concurrency and Parlleism are difficult concepts.
Debugging concurrent software can be one of the difficult things a programmer can do.
Don't be afraid to reach out for help on one of the many Nim communication channels including:

* The Official Nim Forum
* The Nim IRC channel
  - The Nim IRC channel is bridged to several popular chat systems including Discord, Matrix, Gitter.
  - Pick your favorite chat app and get in touch!
