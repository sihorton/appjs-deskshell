chrome-rDebug
=============

Api for using chrome remote debugging protocol. Written to provide a bridge api for AppJS v2.0

The API implements all methods detailed in the spec: https://developers.google.com/chrome-developer-tools/docs/protocol/1.0/

Example Code:
-------------
      
    var rDebug = require('./index.js').rDebug;
    var request = require("request");
     
    request("http://localhost:9222/json", function(error, response, body) {
        var chromeDebugOptions = JSON.parse(body);
        var chromeDebugUrl = chromeDebugOptions[0].webSocketDebuggerUrl;
        var rDebugApi = rDebug.openSocket(chromeDebugUrl);

        rDebugApi.ws.on('close',function() {
            console.log('disconnected');
        });
        var printErr = function(err) {
            console.log("error:"+err.error.code+" "+err.error.message);
        };
        rDebugApi.on('*',function(event) {
            console.log("Event:",event);
        });
        rDebugApi.ws.on('open',function() {
            console.log('connected');
            
            rDebugApi.domGetDocument().then(function(doc) {
                rDebugApi.domGetOuterHTML(doc.root.nodeId)
                .then(function(res) {
                    console.log("page html:",res.outerHTML);
                    rDebugApi.pageNavigate("http://appjs.com").then(function() {
                        setTimeout(function(){
                            rDebugApi.pageNavigate("about:blank")
                        },5000);
                    }).fail(function(err) {
                    console.log("error:"+err.error.code+" "+err.error.message);
                    });
                }).fail(function(err) {
                    console.log("error:"+err.error.code+" "+err.error.message);
                });
            }).fail(printErr);
        });
    });


Page Api:
=========

* pageNavigate(url)
* pageReload
* pageDisableEvents
* pageEnableEvents
 
Console Api:
============
* consoleClearMessages
* consoleEnable
* consoleDisable

DOM Api:
========
* domGetDocument
* domGetOuterHTML
* domHideHighlight
* domHighlightNode
* domHighlightRect
* domMoveTo
* domQuerySelector
* domQuerySelectorAll
* domRemoveAttribute
* domRemoveNode
* domRequestChildNodes
* domRequestNode
* domResolveNode
* domSetAttributeValue
* domSetAttributesAsText
* domSetNodeName
* domSetNodeValue
* domSetOutputHTML

DOM Debugger Api:
=================
* domDebuggerRemoveDomBreakpoint
* domDebuggerRemoveEventListenerBreakpoint
* domDebuggerRemoveXHRBreakpoint
* domDebuggerSetDomBreakpoint
* domDebuggerSetEventListenerBreakpoint
* domDebuggerSetXHRBreakpoint 

Runtime Api:
============
* runtimeCallFunctionOn
* runtimeEvaluate
* runtimeGetProperties
* runtimeReleaseObject
* runtimeReleaseObjectGroup 

Timeline Api:
=============
* timelineStart
* timelineEnd

Network Api:
============
* networkCanClearBrowserCache
* networkCanClearBrowserCookies
* networkClearBrowserCache
* networkClearBrowserCookies
* networkEnableEvents
* networkDisableEvents
* networkGetResponseBody
* networkSetCacheDisabled
* networkSetExtraHTTPHeaders
* networkSetUserAgentOverride

Event Api:
==========
Register to handle a given event, use '*' to handle all events.

Event Api Example code:-

    rDebugApi.on('DOM.documentUpdated',function(event) {
        console.log("Event:document updated");
    });
    rDebugApi.on('*',function(event) {
        //fired for all events.
        console.log("Event:",event);
    });

Methods like consoleEnable will turn on console events so you can handle them. consoleDisable and similar functions will then turn off those events.
