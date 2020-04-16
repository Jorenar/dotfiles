" vim-better-javascript-completion
" GitHub: https://github.com/1995eaton/vim-better-javascript-completion

" (A more up-to-date) Vim completion script
" Language:  JavaScript
" Maintainer:  Jake Eaton (1995eaton@gmail.com)
" Last Change:  2014 Jun 23
" Original Maintainer: Mikolaj Machowski ( mikmach AT wp DOT pl )

if !exists('g:vimjs#casesensitive')
  let g:vimjs#casesensitive = 1
endif

if !exists('g:vimjs#smartcomplete')
  let g:vimjs#smartcomplete = 1
endif

let s:keywords = ['abstract', 'boolean', 'break', 'byte', 'case', 'catch', 'char', 'class', 'continue', 'debugger', 'default', 'delete', 'do', 'double ', 'else', 'enum', 'export', 'extends', 'false', 'final', 'finally', 'float', 'for', 'function', 'goto', 'if', 'implements', 'import', 'in ', 'instanceof', 'int', 'interface', 'long', 'native', 'new', 'null', 'package', 'private', 'protected', 'public', 'return', 'short', 'static', 'super ', 'switch', 'synchronized', 'this', 'throw', 'throws', 'transient', 'true', 'try', 'typeof', 'var', 'void', 'volatile', 'while', 'with', 'console']

if exists('g:vimjs#chromeapis') && g:vimjs#chromeapis == 1
  let s:chromeo = ['Event(', 'app', 'bookmarks', 'browserAction', 'commands', 'csi(', 'downloads', 'extension', 'history', 'i18n', 'loadTimes(', 'management', 'permissions', 'runtime', 'sessions', 'storage', 'tabs', 'test', 'topSites', 'types', 'windows']
  let s:chrometabs = ['captureVisibleTab(', 'connect(', 'create(', 'detectLanguage(', 'duplicate(', 'executeScript(', 'get(', 'getAllInWindow(', 'getCurrent(', 'getSelected(', 'highlight(', 'insertCSS(', 'move(', 'onActivated', 'onActiveChanged', 'onAttached', 'onCreated', 'onDetached', 'onHighlightChanged', 'onHighlighted', 'onMoved', 'onRemoved', 'onReplaced', 'onSelectionChanged', 'onUpdated', 'query(', 'reload(', 'remove(', 'sendMessage(', 'sendRequest(', 'update(']
  let s:chromehist = ['addUrl(', 'deleteAll(', 'deleteRange(', 'deleteUrl(', 'getVisits(', 'onVisitRemoved', 'onVisited', 'search(']
  let s:chromemarks = ['MAX_SUSTAINED_WRITE_OPERATIONS_PER_MINUTE', 'MAX_WRITE_OPERATIONS_PER_HOUR', 'create(', 'get(', 'getChildren(', 'getRecent(', 'getSubTree(', 'getTree(', 'move(', 'onChanged', 'onChildrenReordered', 'onCreated', 'onImportBegan', 'onImportEnded', 'onMoved', 'onRemoved', 'remove(', 'removeTree(', 'search(', 'update(']
  let s:chromecomm = ['getAll(', 'onCommand']
  let s:chromewins = ['WINDOW_ID_CURRENT', 'WINDOW_ID_NONE', 'create(', 'get(', 'getAll(', 'getCurrent(', 'getLastFocused(', 'onCreated', 'onFocusChanged', 'onRemoved', 'remove(', 'update(']
  let s:chromeext = ['connect(', 'connectNative(', 'getBackgroundPage(', 'getURL(', 'getViews(', 'inIncognitoContext', 'isAllowedFileSchemeAccess(', 'isAllowedIncognitoAccess(', 'onConnect', 'onConnectExternal', 'onMessage', 'onMessageExternal', 'onRequest', 'onRequestExternal', 'sendMessage(', 'sendNativeMessage(', 'sendRequest(', 'setUpdateUrlData(']
  let s:chromerunt = ['connect(', 'connectNative(', 'getBackgroundPage(', 'getManifest(', 'getPackageDirectoryEntry(', 'getPlatformInfo(', 'getURL(', 'id', 'onBrowserUpdateAvailable', 'onConnect', 'onConnectExternal', 'onInstalled', 'onMessage', 'onMessageExternal', 'onRestartRequired', 'onStartup', 'onSuspend', 'onSuspendCanceled', 'onUpdateAvailable', 'reload(', 'requestUpdateCheck(', 'restart(', 'sendMessage(', 'sendNativeMessage(', 'setUninstallURL(']
  let s:chrometops = ['get(']
  let s:chromebact = ['disable(', 'enable(', 'getBadgeBackgroundColor(', 'getBadgeText(', 'getPopup(', 'getTitle(', 'onClicked', 'openPopup(', 'setBadgeBackgroundColor(', 'setBadgeText(', 'setIcon(', 'setPopup(', 'setTitle(']
  let s:chromeapp = ['getDetails(', 'getDetailsForFrame(', 'getIsInstalled(', 'installState(', 'isInstalled', 'runningState(']
  let s:chromedown = ['acceptDanger(', 'cancel(', 'download(', 'drag(', 'erase(', 'getFileIcon(', 'onChanged', 'onCreated', 'onDeterminingFilename', 'onErased', 'open(', 'pause(', 'removeFile(', 'resume(', 'search(', 'setShelfEnabled(', 'show(', 'showDefaultFolder(']
  let s:chromeman = ['getPermissionWarningsByManifest(', 'uninstallSelf(']
  let s:chromeperm = ['contains(', 'getAll(', 'onAdded', 'onRemoved', 'remove(', 'request(']
  let s:chromesess = ['MAX_SESSION_RESULTS', 'getDevices(', 'getRecentlyClosed(', 'onChanged', 'restore(']
  let s:chromestor = ['local', 'managed', 'onChanged', 'sync']
  let s:chromestorsync = ['MAX_ITEMS', 'MAX_SUSTAINED_WRITE_OPERATIONS_PER_MINUTE', 'MAX_WRITE_OPERATIONS_PER_HOUR', 'QUOTA_BYTES', 'QUOTA_BYTES_PER_ITEM', 'clear(', 'functionSchemas', 'get(', 'getBytesInUse(', 'remove(', 'set(', 'setSchema(']
  let s:chromestorloc = ['QUOTA_BYTES', 'clear(', 'functionSchemas', 'get(', 'getBytesInUse(', 'remove(', 'set(', 'setSchema(']
else
  let g:vimjs#chromeapis = 0
endif

let s:winds = ['AnalyserNode(', 'AnimationEvent(', 'AppBannerPromptResult(', 'ApplicationCache(', 'ApplicationCacheErrorEvent(', 'Array(', 'ArrayBuffer(', 'Attr(', 'Audio(', 'AudioBuffer(', 'AudioBufferSourceNode(', 'AudioContext(', 'AudioDestinationNode(', 'AudioListener(', 'AudioNode(', 'AudioParam(', 'AudioProcessingEvent(', 'BarProp(', 'BatteryManager(', 'BeforeInstallPromptEvent(', 'BeforeUnloadEvent(', 'BiquadFilterNode(', 'Blob(', 'BlobEvent(', 'Boolean(', 'ByteLengthQueuingStrategy(', 'CDATASection(', 'CSS(', 'CSSFontFaceRule(', 'CSSGroupingRule(', 'CSSImportRule(', 'CSSKeyframeRule(', 'CSSKeyframesRule(', 'CSSMediaRule(', 'CSSNamespaceRule(', 'CSSPageRule(', 'CSSRule(', 'CSSRuleList(', 'CSSStyleDeclaration(', 'CSSStyleRule(', 'CSSStyleSheet(', 'CSSSupportsRule(', 'CSSViewportRule(', 'Cache(', 'CacheStorage(', 'CanvasCaptureMediaStreamTrack(', 'CanvasGradient(', 'CanvasPattern(', 'CanvasRenderingContext2D(', 'ChannelMergerNode(', 'ChannelSplitterNode(', 'CharacterData(', 'ClientRect(', 'ClientRectList(', 'ClipboardEvent(', 'CloseEvent(', 'Comment(', 'CompositionEvent(', 'ConvolverNode(', 'CountQueuingStrategy(', 'Credential(', 'CredentialsContainer(', 'Crypto(', 'CryptoKey(', 'CustomEvent(', 'DOMError(', 'DOMException(', 'DOMImplementation(', 'DOMParser(', 'DOMStringList(', 'DOMStringMap(', 'DOMTokenList(', 'DataTransfer(', 'DataTransferItem(', 'DataTransferItemList(', 'DataView(', 'Date(', 'DelayNode(', 'DeviceMotionEvent(', 'DeviceOrientationEvent(', 'Document(', 'DocumentFragment(', 'DocumentType(', 'DragEvent(', 'DynamicsCompressorNode(', 'Element(', 'Error(', 'ErrorEvent(', 'EvalError(', 'Event(', 'EventSource(', 'EventTarget(', 'FederatedCredential(', 'File(', 'FileError(', 'FileList(', 'FileReader(', 'Float32Array(', 'Float64Array(', 'FocusEvent(', 'FontFace(', 'FormData(', 'Function(', 'GainNode(', 'Gamepad(', 'GamepadButton(', 'GamepadEvent(', 'HTMLAllCollection(', 'HTMLAnchorElement(', 'HTMLAreaElement(', 'HTMLAudioElement(', 'HTMLBRElement(', 'HTMLBaseElement(', 'HTMLBodyElement(', 'HTMLButtonElement(', 'HTMLCanvasElement(', 'HTMLCollection(', 'HTMLContentElement(', 'HTMLDListElement(', 'HTMLDataListElement(', 'HTMLDetailsElement(', 'HTMLDialogElement(', 'HTMLDirectoryElement(', 'HTMLDivElement(', 'HTMLDocument(', 'HTMLElement(', 'HTMLEmbedElement(', 'HTMLFieldSetElement(', 'HTMLFontElement(', 'HTMLFormControlsCollection(', 'HTMLFormElement(', 'HTMLFrameElement(', 'HTMLFrameSetElement(', 'HTMLHRElement(', 'HTMLHeadElement(', 'HTMLHeadingElement(', 'HTMLHtmlElement(', 'HTMLIFrameElement(', 'HTMLImageElement(', 'HTMLInputElement(', 'HTMLKeygenElement(', 'HTMLLIElement(', 'HTMLLabelElement(', 'HTMLLegendElement(', 'HTMLLinkElement(', 'HTMLMapElement(', 'HTMLMarqueeElement(', 'HTMLMediaElement(', 'HTMLMenuElement(', 'HTMLMetaElement(', 'HTMLMeterElement(', 'HTMLModElement(', 'HTMLOListElement(', 'HTMLObjectElement(', 'HTMLOptGroupElement(', 'HTMLOptionElement(', 'HTMLOptionsCollection(', 'HTMLOutputElement(', 'HTMLParagraphElement(', 'HTMLParamElement(', 'HTMLPictureElement(', 'HTMLPreElement(', 'HTMLProgressElement(', 'HTMLQuoteElement(', 'HTMLScriptElement(', 'HTMLSelectElement(', 'HTMLShadowElement(', 'HTMLSourceElement(', 'HTMLSpanElement(', 'HTMLStyleElement(', 'HTMLTableCaptionElement(', 'HTMLTableCellElement(', 'HTMLTableColElement(', 'HTMLTableElement(', 'HTMLTableRowElement(', 'HTMLTableSectionElement(', 'HTMLTemplateElement(', 'HTMLTextAreaElement(', 'HTMLTitleElement(', 'HTMLTrackElement(', 'HTMLUListElement(', 'HTMLUnknownElement(', 'HTMLVideoElement(', 'HashChangeEvent(', 'Headers(', 'History(', 'IDBCursor(', 'IDBCursorWithValue(', 'IDBDatabase(', 'IDBFactory(', 'IDBIndex(', 'IDBKeyRange(', 'IDBObjectStore(', 'IDBOpenDBRequest(', 'IDBRequest(', 'IDBTransaction(', 'IDBVersionChangeEvent(', 'IIRFilterNode(', 'IdleDeadline(', 'Image(', 'ImageBitmap(', 'ImageData(', 'Infinity', 'InputDeviceCapabilities(', 'Int16Array(', 'Int32Array(', 'Int8Array(', 'IntersectionObserver(', 'IntersectionObserverEntry(', 'Intl', 'JSON', 'KeyboardEvent(', 'Location(', 'MIDIAccess(', 'MIDIConnectionEvent(', 'MIDIInput(', 'MIDIInputMap(', 'MIDIMessageEvent(', 'MIDIOutput(', 'MIDIOutputMap(', 'MIDIPort(', 'Map(', 'Math', 'MediaDevices(', 'MediaElementAudioSourceNode(', 'MediaEncryptedEvent(', 'MediaError(', 'MediaKeyMessageEvent(', 'MediaKeySession(', 'MediaKeyStatusMap(', 'MediaKeySystemAccess(', 'MediaKeys(', 'MediaList(', 'MediaQueryList(', 'MediaQueryListEvent(', 'MediaRecorder(', 'MediaSource(', 'MediaStreamAudioDestinationNode(', 'MediaStreamAudioSourceNode(', 'MediaStreamEvent(', 'MediaStreamTrack(', 'MessageChannel(', 'MessageEvent(', 'MessagePort(', 'MimeType(', 'MimeTypeArray(', 'MouseEvent(', 'MutationEvent(', 'MutationObserver(', 'MutationRecord(', 'NaN', 'NamedNodeMap(', 'Navigator(', 'Node(', 'NodeFilter(', 'NodeIterator(', 'NodeList(', 'Notification(', 'Number(', 'Object(', 'OfflineAudioCompletionEvent(', 'OfflineAudioContext(', 'Option(', 'OscillatorNode(', 'PERSISTENT', 'PageTransitionEvent(', 'PasswordCredential(', 'Path2D(', 'Performance(', 'PerformanceEntry(', 'PerformanceMark(', 'PerformanceMeasure(', 'PerformanceNavigation(', 'PerformanceObserver(', 'PerformanceObserverEntryList(', 'PerformanceResourceTiming(', 'PerformanceTiming(', 'PeriodicWave(', 'PermissionStatus(', 'Permissions(', 'Plugin(', 'PluginArray(', 'PopStateEvent(', 'Presentation(', 'PresentationAvailability(', 'PresentationConnection(', 'PresentationConnectionAvailableEvent(', 'PresentationConnectionCloseEvent(', 'PresentationRequest(', 'ProcessingInstruction(', 'ProgressEvent(', 'Promise(', 'PromiseRejectionEvent(', 'Proxy(', 'PushManager(', 'PushSubscription(', 'RTCCertificate(', 'RTCIceCandidate(', 'RTCSessionDescription(', 'RadioNodeList(', 'Range(', 'RangeError(', 'ReadableStream(', 'ReferenceError(', 'Reflect', 'RegExp(', 'Request(', 'Response(', 'SVGAElement(', 'SVGAngle(', 'SVGAnimateElement(', 'SVGAnimateMotionElement(', 'SVGAnimateTransformElement(', 'SVGAnimatedAngle(', 'SVGAnimatedBoolean(', 'SVGAnimatedEnumeration(', 'SVGAnimatedInteger(', 'SVGAnimatedLength(', 'SVGAnimatedLengthList(', 'SVGAnimatedNumber(', 'SVGAnimatedNumberList(', 'SVGAnimatedPreserveAspectRatio(', 'SVGAnimatedRect(', 'SVGAnimatedString(', 'SVGAnimatedTransformList(', 'SVGAnimationElement(', 'SVGCircleElement(', 'SVGClipPathElement(', 'SVGComponentTransferFunctionElement(', 'SVGCursorElement(', 'SVGDefsElement(', 'SVGDescElement(', 'SVGDiscardElement(', 'SVGElement(', 'SVGEllipseElement(', 'SVGFEBlendElement(', 'SVGFEColorMatrixElement(', 'SVGFEComponentTransferElement(', 'SVGFECompositeElement(', 'SVGFEConvolveMatrixElement(', 'SVGFEDiffuseLightingElement(', 'SVGFEDisplacementMapElement(', 'SVGFEDistantLightElement(', 'SVGFEDropShadowElement(', 'SVGFEFloodElement(', 'SVGFEFuncAElement(', 'SVGFEFuncBElement(', 'SVGFEFuncGElement(', 'SVGFEFuncRElement(', 'SVGFEGaussianBlurElement(', 'SVGFEImageElement(', 'SVGFEMergeElement(', 'SVGFEMergeNodeElement(', 'SVGFEMorphologyElement(', 'SVGFEOffsetElement(', 'SVGFEPointLightElement(', 'SVGFESpecularLightingElement(', 'SVGFESpotLightElement(', 'SVGFETileElement(', 'SVGFETurbulenceElement(', 'SVGFilterElement(', 'SVGForeignObjectElement(', 'SVGGElement(', 'SVGGeometryElement(', 'SVGGradientElement(', 'SVGGraphicsElement(', 'SVGImageElement(', 'SVGLength(', 'SVGLengthList(', 'SVGLineElement(', 'SVGLinearGradientElement(', 'SVGMPathElement(', 'SVGMarkerElement(', 'SVGMaskElement(', 'SVGMatrix(', 'SVGMetadataElement(', 'SVGNumber(', 'SVGNumberList(', 'SVGPathElement(', 'SVGPatternElement(', 'SVGPoint(', 'SVGPointList(', 'SVGPolygonElement(', 'SVGPolylineElement(', 'SVGPreserveAspectRatio(', 'SVGRadialGradientElement(', 'SVGRect(', 'SVGRectElement(', 'SVGSVGElement(', 'SVGScriptElement(', 'SVGSetElement(', 'SVGStopElement(', 'SVGStringList(', 'SVGStyleElement(', 'SVGSwitchElement(', 'SVGSymbolElement(', 'SVGTSpanElement(', 'SVGTextContentElement(', 'SVGTextElement(', 'SVGTextPathElement(', 'SVGTextPositioningElement(', 'SVGTitleElement(', 'SVGTransform(', 'SVGTransformList(', 'SVGUnitTypes(', 'SVGUseElement(', 'SVGViewElement(', 'SVGViewSpec(', 'SVGZoomEvent(', 'Screen(', 'ScreenOrientation(', 'ScriptProcessorNode(', 'SecurityPolicyViolationEvent(', 'Selection(', 'ServiceWorker(', 'ServiceWorkerContainer(', 'ServiceWorkerMessageEvent(', 'ServiceWorkerRegistration(', 'Set(', 'ShadowRoot(', 'SharedWorker(', 'SiteBoundCredential(', 'SourceBuffer(', 'SourceBufferList(', 'SpeechSynthesisEvent(', 'SpeechSynthesisUtterance(', 'Storage(', 'StorageEvent(', 'StorageManager', 'String(', 'StyleSheet(', 'StyleSheetList(', 'SubtleCrypto(', 'Symbol(', 'SyncManager(', 'SyntaxError(', 'TEMPORARY', 'Text(', 'TextDecoder(', 'TextEncoder(', 'TextEvent(', 'TextMetrics(', 'TextTrack(', 'TextTrackCue(', 'TextTrackCueList(', 'TextTrackList(', 'TimeRanges(', 'Touch(', 'TouchEvent(', 'TouchList(', 'TrackEvent(', 'TransitionEvent(', 'TreeWalker(', 'TypeError(', 'UIEvent(', 'URIError(', 'URL(', 'URLSearchParams(', 'Uint16Array(', 'Uint32Array(', 'Uint8Array(', 'Uint8ClampedArray(', 'VTTCue(', 'ValidityState(', 'WaveShaperNode(', 'WeakMap(', 'WeakSet(', 'WebGLActiveInfo(', 'WebGLBuffer(', 'WebGLContextEvent(', 'WebGLFramebuffer(', 'WebGLProgram(', 'WebGLRenderbuffer(', 'WebGLRenderingContext(', 'WebGLShader(', 'WebGLShaderPrecisionFormat(', 'WebGLTexture(', 'WebGLUniformLocation(', 'WebKitAnimationEvent(', 'WebKitCSSMatrix(', 'WebKitMutationObserver(', 'WebKitTransitionEvent(', 'WebSocket(', 'WheelEvent(', 'Window(', 'Worker(', 'XMLDocument(', 'XMLHttpRequest(', 'XMLHttpRequestEventTarget(', 'XMLHttpRequestUpload(', 'XMLSerializer(', 'XPathEvaluator(', 'XPathExpression(', 'XPathResult(', 'XSLTProcessor(', 'addEventListener(', 'alert(', 'applicationCache', 'atob(', 'blur(', 'btoa(', 'caches', 'cancelAnimationFrame(', 'cancelIdleCallback(', 'captureEvents(', 'chrome', 'clearInterval(', 'clearTimeout(', 'clientInformation', 'close(', 'closed', 'confirm(', 'console', 'createImageBitmap(', 'crypto', 'decodeURI(', 'decodeURIComponent(', 'defaultStatus', 'defaultstatus', 'devicePixelRatio', 'dispatchEvent(', 'document', 'encodeURI(', 'encodeURIComponent(', 'escape(', 'eval(', 'event', 'external', 'fetch(', 'find(', 'focus(', 'frameElement', 'frames', 'getComputedStyle(', 'getMatchedCSSRules(', 'getSelection(', 'history', 'indexedDB', 'innerHeight', 'innerWidth', 'isFinite(', 'isNaN(', 'isSecureContext', 'length', 'localStorage', 'location', 'locationbar', 'matchMedia(', 'menubar', 'moveBy(', 'moveTo(', 'navigator', 'offscreenBuffering', 'onabort', 'onanimationend', 'onanimationiteration', 'onanimationstart', 'onbeforeunload', 'onblur', 'oncancel', 'oncanplay', 'oncanplaythrough', 'onchange', 'onclick', 'onclose', 'oncontextmenu', 'oncuechange', 'ondblclick', 'ondevicemotion', 'ondeviceorientation', 'ondeviceorientationabsolute', 'ondrag', 'ondragend', 'ondragenter', 'ondragleave', 'ondragover', 'ondragstart', 'ondrop', 'ondurationchange', 'onemptied', 'onended', 'onerror', 'onfocus', 'onhashchange', 'oninput', 'oninvalid', 'onkeydown', 'onkeypress', 'onkeyup', 'onlanguagechange', 'onload', 'onloadeddata', 'onloadedmetadata', 'onloadstart', 'onmessage', 'onmousedown', 'onmouseenter', 'onmouseleave', 'onmousemove', 'onmouseout', 'onmouseover', 'onmouseup', 'onmousewheel', 'onoffline', 'ononline', 'onpagehide', 'onpageshow', 'onpause', 'onplay', 'onplaying', 'onpopstate', 'onprogress', 'onratechange', 'onrejectionhandled', 'onreset', 'onresize', 'onscroll', 'onsearch', 'onseeked', 'onseeking', 'onselect', 'onshow', 'onstalled', 'onstorage', 'onsubmit', 'onsuspend', 'ontimeupdate', 'ontoggle', 'ontransitionend', 'onunhandledrejection', 'onunload', 'onvolumechange', 'onwaiting', 'onwebkitanimationend', 'onwebkitanimationiteration', 'onwebkitanimationstart', 'onwebkittransitionend', 'onwheel', 'open(', 'openDatabase(', 'opener', 'outerHeight', 'outerWidth', 'pageXOffset', 'pageYOffset', 'parent', 'parseFloat(', 'parseInt(', 'performance', 'personalbar', 'postMessage(', 'print(', 'prompt(', 'releaseEvents(', 'removeEventListener(', 'requestAnimationFrame(', 'requestIdleCallback(', 'resizeBy(', 'resizeTo(', 'screen', 'screenLeft', 'screenTop', 'screenX', 'screenY', 'scroll(', 'scrollBy(', 'scrollTo(', 'scrollX', 'scrollY', 'scrollbars', 'self', 'sessionStorage', 'setInterval(', 'setTimeout(', 'speechSynthesis', 'status', 'statusbar', 'stop(', 'styleMedia', 'toolbar', 'top', 'undefined', 'unescape(', 'webkitAudioContext(', 'webkitCancelAnimationFrame(', 'webkitCancelRequestAnimationFrame(', 'webkitIDBCursor(', 'webkitIDBDatabase(', 'webkitIDBFactory(', 'webkitIDBIndex(', 'webkitIDBKeyRange(', 'webkitIDBObjectStore(', 'webkitIDBRequest(', 'webkitIDBTransaction(', 'webkitIndexedDB', 'webkitMediaStream(', 'webkitOfflineAudioContext(', 'webkitRTCPeerConnection(', 'webkitRequestAnimationFrame(', 'webkitRequestFileSystem(', 'webkitResolveLocalFileSystemURL(', 'webkitSpeechGrammar(', 'webkitSpeechGrammarList(', 'webkitSpeechRecognition(', 'webkitSpeechRecognitionError(', 'webkitSpeechRecognitionEvent(', 'webkitStorageInfo', 'webkitURL(', 'window']

let s:arrays = ['concat(', 'constructor(', 'copyWithin(', 'entries(', 'every(', 'fill(', 'filter(', 'find(', 'findIndex(', 'forEach(', 'includes(', 'indexOf(', 'isArray(', 'join(', 'keys(', 'lastIndexOf(', 'length', 'map(', 'pop(', 'push(', 'reduce(', 'reduceRight(', 'reverse(', 'shift(', 'slice(', 'some(', 'sort(', 'splice(', 'toLocaleString(', 'toString(', 'unshift(', 'values(']

let s:dates = ['UTC(', 'constructor(', 'getDate(', 'getDay(', 'getFullYear(', 'getHours(', 'getMilliseconds(', 'getMinutes(', 'getMonth(', 'getSeconds(', 'getTime(', 'getTimezoneOffset(', 'getUTCDate(', 'getUTCDay(', 'getUTCFullYear(', 'getUTCHours(', 'getUTCMilliseconds(', 'getUTCMinutes(', 'getUTCMonth(', 'getUTCSeconds(', 'getYear(', 'length', 'now(', 'parse(', 'setDate(', 'setFullYear(', 'setHours(', 'setMilliseconds(', 'setMinutes(', 'setMonth(', 'setSeconds(', 'setTime(', 'setUTCDate(', 'setUTCFullYear(', 'setUTCHours(', 'setUTCMilliseconds(', 'setUTCMinutes(', 'setUTCMonth(', 'setUTCSeconds(', 'setYear(', 'toDateString(', 'toGMTString(', 'toISOString(', 'toJSON(', 'toLocaleDateString(', 'toLocaleString(', 'toLocaleTimeString(', 'toString(', 'toTimeString(', 'toUTCString(', 'valueOf(']

let s:funcs = ['apply(', 'arguments', 'bind(', 'call(', 'caller', 'constructor(', 'length', 'name', 'prototype(', 'toString(']

let s:maths = ['E', 'LN10', 'LN2', 'LOG10E', 'LOG2E', 'PI', 'SQRT1_2', 'SQRT2', 'abs(', 'acos(', 'acosh(', 'asin(', 'asinh(', 'atan(', 'atan2(', 'atanh(', 'cbrt(', 'ceil(', 'clz32(', 'cos(', 'cosh(', 'exp(', 'expm1(', 'floor(', 'fround(', 'hypot(', 'imul(', 'log(', 'log10(', 'log1p(', 'log2(', 'max(', 'min(', 'pow(', 'random(', 'round(', 'sign(', 'sin(', 'sinh(', 'sqrt(', 'tan(', 'tanh(', 'trunc(']

let s:numbs = ['EPSILON', 'MAX_SAFE_INTEGER', 'MAX_VALUE', 'MIN_SAFE_INTEGER', 'MIN_VALUE', 'NEGATIVE_INFINITY', 'NaN', 'POSITIVE_INFINITY', 'constructor(', 'isFinite(', 'isInteger(', 'isNaN(', 'isSafeInteger(', 'parseFloat(', 'parseInt(', 'toExponential(', 'toFixed(', 'toLocaleString(', 'toPrecision(', 'toString(', 'valueOf(']

let s:evnts = ['AT_TARGET', 'BLUR', 'BUBBLING_PHASE', 'CAPTURING_PHASE', 'CHANGE', 'CLICK', 'DBLCLICK', 'DOM_KEY_LOCATION_LEFT', 'DOM_KEY_LOCATION_NUMPAD', 'DOM_KEY_LOCATION_RIGHT', 'DOM_KEY_LOCATION_STANDARD', 'DRAGDROP', 'FOCUS', 'KEYDOWN', 'KEYPRESS', 'KEYUP', 'MOUSEDOWN', 'MOUSEDRAG', 'MOUSEMOVE', 'MOUSEOUT', 'MOUSEOVER', 'MOUSEUP', 'NONE', 'SELECT', 'altGraphKey', 'altKey', 'bubbles', 'button', 'cancelBubble', 'cancelable', 'charCode', 'clientX', 'clientY', 'clipboardData', 'ctrlKey', 'currentTarget', 'dataTransfer', 'defaultPrevented', 'detail', 'eventPhase', 'fromElement', 'getModifierState(', 'initEvent(', 'initKeyboardEvent(', 'initMouseEvent(', 'initUIEvent(', 'keyCode', 'keyIdentifier', 'keyLocation', 'layerX', 'layerY', 'location', 'metaKey', 'movementX', 'movementY', 'offsetX', 'offsetY', 'pageX', 'pageY', 'path', 'preventDefault(', 'relatedTarget', 'repeat', 'returnValue', 'screenX', 'screenY', 'shiftKey', 'srcElement', 'stopImmediatePropagation(', 'stopPropagation(', 'target', 'timeStamp', 'toElement', 'type', 'view', 'webkitMovementX', 'webkitMovementY', 'which', 'x', 'y']

let s:locas = ['ancestorOrigins', 'assign(', 'hash', 'host', 'hostname', 'href', 'origin', 'pathname', 'port', 'protocol', 'reload(', 'replace(', 'search', 'toString(', 'valueOf(']

let s:objes = ['assign(', 'constructor(', 'create(', 'defineProperties(', 'defineProperty(', 'entries(', 'freeze(', 'getOwnPropertyDescriptor(', 'getOwnPropertyDescriptors(', 'getOwnPropertyNames(', 'getOwnPropertySymbols(', 'getPrototypeOf(', 'hasOwnProperty(', 'is(', 'isExtensible(', 'isFrozen(', 'isPrototypeOf(', 'isSealed(', 'keys(', 'length', 'preventExtensions(', 'propertyIsEnumerable(', 'seal(', 'setPrototypeOf(', 'toLocaleString(', 'toString(', 'valueOf(', 'values(']

let s:reges = ['compile(', 'constructor(', 'exec(', 'flags', 'global', 'ignoreCase', 'input', 'lastMatch', 'lastParen', 'leftContext', 'multiline', 'rightContext', 'source', 'sticky', 'test(', 'toString(', 'unicode']

let s:stris = ['anchor(', 'big(', 'blink(', 'bold(', 'charAt(', 'charCodeAt(', 'codePointAt(', 'concat(', 'constructor(', 'endsWith(', 'fixed(', 'fontcolor(', 'fontsize(', 'fromCharCode(', 'fromCodePoint(', 'includes(', 'indexOf(', 'italics(', 'lastIndexOf(', 'length', 'link(', 'localeCompare(', 'match(', 'normalize(', 'padEnd(', 'padStart(', 'raw(', 'repeat(', 'replace(', 'search(', 'slice(', 'small(', 'split(', 'startsWith(', 'strike(', 'sub(', 'substr(', 'substring(', 'sup(', 'toLocaleLowerCase(', 'toLocaleUpperCase(', 'toLowerCase(', 'toString(', 'toUpperCase(', 'trim(', 'trimLeft(', 'trimRight(', 'valueOf(']

let s:webgl = ['ACTIVE_ATTRIBUTES', 'ACTIVE_TEXTURE', 'ACTIVE_UNIFORMS', 'ALIASED_LINE_WIDTH_RANGE', 'ALIASED_POINT_SIZE_RANGE', 'ALPHA', 'ALPHA_BITS', 'ALWAYS', 'ARRAY_BUFFER', 'ARRAY_BUFFER_BINDING', 'ATTACHED_SHADERS', 'BACK', 'BLEND', 'BLEND_COLOR', 'BLEND_DST_ALPHA', 'BLEND_DST_RGB', 'BLEND_EQUATION', 'BLEND_EQUATION_ALPHA', 'BLEND_EQUATION_RGB', 'BLEND_SRC_ALPHA', 'BLEND_SRC_RGB', 'BLUE_BITS', 'BOOL', 'BOOL_VEC2', 'BOOL_VEC3', 'BOOL_VEC4', 'BROWSER_DEFAULT_WEBGL', 'BUFFER_SIZE', 'BUFFER_USAGE', 'BYTE', 'CCW', 'CLAMP_TO_EDGE', 'COLOR_ATTACHMENT0', 'COLOR_BUFFER_BIT', 'COLOR_CLEAR_VALUE', 'COLOR_WRITEMASK', 'COMPILE_STATUS', 'COMPRESSED_TEXTURE_FORMATS', 'CONSTANT_ALPHA', 'CONSTANT_COLOR', 'CONTEXT_LOST_WEBGL', 'CULL_FACE', 'CULL_FACE_MODE', 'CURRENT_PROGRAM', 'CURRENT_VERTEX_ATTRIB', 'CW', 'DECR', 'DECR_WRAP', 'DELETE_STATUS', 'DEPTH_ATTACHMENT', 'DEPTH_BITS', 'DEPTH_BUFFER_BIT', 'DEPTH_CLEAR_VALUE', 'DEPTH_COMPONENT', 'DEPTH_COMPONENT16', 'DEPTH_FUNC', 'DEPTH_RANGE', 'DEPTH_STENCIL', 'DEPTH_STENCIL_ATTACHMENT', 'DEPTH_TEST', 'DEPTH_WRITEMASK', 'DITHER', 'DONT_CARE', 'DST_ALPHA', 'DST_COLOR', 'DYNAMIC_DRAW', 'ELEMENT_ARRAY_BUFFER', 'ELEMENT_ARRAY_BUFFER_BINDING', 'EQUAL', 'FASTEST', 'FLOAT', 'FLOAT_MAT2', 'FLOAT_MAT3', 'FLOAT_MAT4', 'FLOAT_VEC2', 'FLOAT_VEC3', 'FLOAT_VEC4', 'FRAGMENT_SHADER', 'FRAMEBUFFER', 'FRAMEBUFFER_ATTACHMENT_OBJECT_NAME', 'FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE', 'FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE', 'FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL', 'FRAMEBUFFER_BINDING', 'FRAMEBUFFER_COMPLETE', 'FRAMEBUFFER_INCOMPLETE_ATTACHMENT', 'FRAMEBUFFER_INCOMPLETE_DIMENSIONS', 'FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT', 'FRAMEBUFFER_UNSUPPORTED', 'FRONT', 'FRONT_AND_BACK', 'FRONT_FACE', 'FUNC_ADD', 'FUNC_REVERSE_SUBTRACT', 'FUNC_SUBTRACT', 'GENERATE_MIPMAP_HINT', 'GEQUAL', 'GREATER', 'GREEN_BITS', 'HIGH_FLOAT', 'HIGH_INT', 'IMPLEMENTATION_COLOR_READ_FORMAT', 'IMPLEMENTATION_COLOR_READ_TYPE', 'INCR', 'INCR_WRAP', 'INT', 'INT_VEC2', 'INT_VEC3', 'INT_VEC4', 'INVALID_ENUM', 'INVALID_FRAMEBUFFER_OPERATION', 'INVALID_OPERATION', 'INVALID_VALUE', 'INVERT', 'KEEP', 'LEQUAL', 'LESS', 'LINEAR', 'LINEAR_MIPMAP_LINEAR', 'LINEAR_MIPMAP_NEAREST', 'LINES', 'LINE_LOOP', 'LINE_STRIP', 'LINE_WIDTH', 'LINK_STATUS', 'LOW_FLOAT', 'LOW_INT', 'LUMINANCE', 'LUMINANCE_ALPHA', 'MAX_COMBINED_TEXTURE_IMAGE_UNITS', 'MAX_CUBE_MAP_TEXTURE_SIZE', 'MAX_FRAGMENT_UNIFORM_VECTORS', 'MAX_RENDERBUFFER_SIZE', 'MAX_TEXTURE_IMAGE_UNITS', 'MAX_TEXTURE_SIZE', 'MAX_VARYING_VECTORS', 'MAX_VERTEX_ATTRIBS', 'MAX_VERTEX_TEXTURE_IMAGE_UNITS', 'MAX_VERTEX_UNIFORM_VECTORS', 'MAX_VIEWPORT_DIMS', 'MEDIUM_FLOAT', 'MEDIUM_INT', 'MIRRORED_REPEAT', 'NEAREST', 'NEAREST_MIPMAP_LINEAR', 'NEAREST_MIPMAP_NEAREST', 'NEVER', 'NICEST', 'NONE', 'NOTEQUAL', 'NO_ERROR', 'ONE', 'ONE_MINUS_CONSTANT_ALPHA', 'ONE_MINUS_CONSTANT_COLOR', 'ONE_MINUS_DST_ALPHA', 'ONE_MINUS_DST_COLOR', 'ONE_MINUS_SRC_ALPHA', 'ONE_MINUS_SRC_COLOR', 'OUT_OF_MEMORY', 'PACK_ALIGNMENT', 'POINTS', 'POLYGON_OFFSET_FACTOR', 'POLYGON_OFFSET_FILL', 'POLYGON_OFFSET_UNITS', 'RED_BITS', 'RENDERBUFFER', 'RENDERBUFFER_ALPHA_SIZE', 'RENDERBUFFER_BINDING', 'RENDERBUFFER_BLUE_SIZE', 'RENDERBUFFER_DEPTH_SIZE', 'RENDERBUFFER_GREEN_SIZE', 'RENDERBUFFER_HEIGHT', 'RENDERBUFFER_INTERNAL_FORMAT', 'RENDERBUFFER_RED_SIZE', 'RENDERBUFFER_STENCIL_SIZE', 'RENDERBUFFER_WIDTH', 'RENDERER', 'REPEAT', 'REPLACE', 'RGB', 'RGB565', 'RGB5_A1', 'RGBA', 'RGBA4', 'SAMPLER_2D', 'SAMPLER_CUBE', 'SAMPLES', 'SAMPLE_ALPHA_TO_COVERAGE', 'SAMPLE_BUFFERS', 'SAMPLE_COVERAGE', 'SAMPLE_COVERAGE_INVERT', 'SAMPLE_COVERAGE_VALUE', 'SCISSOR_BOX', 'SCISSOR_TEST', 'SHADER_TYPE', 'SHADING_LANGUAGE_VERSION', 'SHORT', 'SRC_ALPHA', 'SRC_ALPHA_SATURATE', 'SRC_COLOR', 'STATIC_DRAW', 'STENCIL_ATTACHMENT', 'STENCIL_BACK_FAIL', 'STENCIL_BACK_FUNC', 'STENCIL_BACK_PASS_DEPTH_FAIL', 'STENCIL_BACK_PASS_DEPTH_PASS', 'STENCIL_BACK_REF', 'STENCIL_BACK_VALUE_MASK', 'STENCIL_BACK_WRITEMASK', 'STENCIL_BITS', 'STENCIL_BUFFER_BIT', 'STENCIL_CLEAR_VALUE', 'STENCIL_FAIL', 'STENCIL_FUNC', 'STENCIL_INDEX', 'STENCIL_INDEX8', 'STENCIL_PASS_DEPTH_FAIL', 'STENCIL_PASS_DEPTH_PASS', 'STENCIL_REF', 'STENCIL_TEST', 'STENCIL_VALUE_MASK', 'STENCIL_WRITEMASK', 'STREAM_DRAW', 'SUBPIXEL_BITS', 'TEXTURE', 'TEXTURE0', 'TEXTURE1', 'TEXTURE10', 'TEXTURE11', 'TEXTURE12', 'TEXTURE13', 'TEXTURE14', 'TEXTURE15', 'TEXTURE16', 'TEXTURE17', 'TEXTURE18', 'TEXTURE19', 'TEXTURE2', 'TEXTURE20', 'TEXTURE21', 'TEXTURE22', 'TEXTURE23', 'TEXTURE24', 'TEXTURE25', 'TEXTURE26', 'TEXTURE27', 'TEXTURE28', 'TEXTURE29', 'TEXTURE3', 'TEXTURE30', 'TEXTURE31', 'TEXTURE4', 'TEXTURE5', 'TEXTURE6', 'TEXTURE7', 'TEXTURE8', 'TEXTURE9', 'TEXTURE_2D', 'TEXTURE_BINDING_2D', 'TEXTURE_BINDING_CUBE_MAP', 'TEXTURE_CUBE_MAP', 'TEXTURE_CUBE_MAP_NEGATIVE_X', 'TEXTURE_CUBE_MAP_NEGATIVE_Y', 'TEXTURE_CUBE_MAP_NEGATIVE_Z', 'TEXTURE_CUBE_MAP_POSITIVE_X', 'TEXTURE_CUBE_MAP_POSITIVE_Y', 'TEXTURE_CUBE_MAP_POSITIVE_Z', 'TEXTURE_MAG_FILTER', 'TEXTURE_MIN_FILTER', 'TEXTURE_WRAP_S', 'TEXTURE_WRAP_T', 'TRIANGLES', 'TRIANGLE_FAN', 'TRIANGLE_STRIP', 'UNPACK_ALIGNMENT', 'UNPACK_COLORSPACE_CONVERSION_WEBGL', 'UNPACK_FLIP_Y_WEBGL', 'UNPACK_PREMULTIPLY_ALPHA_WEBGL', 'UNSIGNED_BYTE', 'UNSIGNED_INT', 'UNSIGNED_SHORT', 'UNSIGNED_SHORT_4_4_4_4', 'UNSIGNED_SHORT_5_5_5_1', 'UNSIGNED_SHORT_5_6_5', 'VALIDATE_STATUS', 'VENDOR', 'VERSION', 'VERTEX_ATTRIB_ARRAY_BUFFER_BINDING', 'VERTEX_ATTRIB_ARRAY_ENABLED', 'VERTEX_ATTRIB_ARRAY_NORMALIZED', 'VERTEX_ATTRIB_ARRAY_POINTER', 'VERTEX_ATTRIB_ARRAY_SIZE', 'VERTEX_ATTRIB_ARRAY_STRIDE', 'VERTEX_ATTRIB_ARRAY_TYPE', 'VERTEX_SHADER', 'VIEWPORT', 'ZERO', 'activeTexture(', 'attachShader(', 'bindAttribLocation(', 'bindBuffer(', 'bindFramebuffer(', 'bindRenderbuffer(', 'bindTexture(', 'blendColor(', 'blendEquation(', 'blendEquationSeparate(', 'blendFunc(', 'blendFuncSeparate(', 'bufferData(', 'bufferSubData(', 'canvas', 'checkFramebufferStatus(', 'clear(', 'clearColor(', 'clearDepth(', 'clearStencil(', 'colorMask(', 'compileShader(', 'compressedTexImage2D(', 'compressedTexSubImage2D(', 'copyTexImage2D(', 'copyTexSubImage2D(', 'createBuffer(', 'createFramebuffer(', 'createProgram(', 'createRenderbuffer(', 'createShader(', 'createTexture(', 'cullFace(', 'deleteBuffer(', 'deleteFramebuffer(', 'deleteProgram(', 'deleteRenderbuffer(', 'deleteShader(', 'deleteTexture(', 'depthFunc(', 'depthMask(', 'depthRange(', 'detachShader(', 'disable(', 'disableVertexAttribArray(', 'drawArrays(', 'drawElements(', 'drawingBufferHeight', 'drawingBufferWidth', 'enable(', 'enableVertexAttribArray(', 'finish(', 'flush(', 'framebufferRenderbuffer(', 'framebufferTexture2D(', 'frontFace(', 'generateMipmap(', 'getActiveAttrib(', 'getActiveUniform(', 'getAttachedShaders(', 'getAttribLocation(', 'getBufferParameter(', 'getContextAttributes(', 'getError(', 'getExtension(', 'getFramebufferAttachmentParameter(', 'getParameter(', 'getProgramInfoLog(', 'getProgramParameter(', 'getRenderbufferParameter(', 'getShaderInfoLog(', 'getShaderParameter(', 'getShaderPrecisionFormat(', 'getShaderSource(', 'getSupportedExtensions(', 'getTexParameter(', 'getUniform(', 'getUniformLocation(', 'getVertexAttrib(', 'getVertexAttribOffset(', 'hint(', 'isBuffer(', 'isContextLost(', 'isEnabled(', 'isFramebuffer(', 'isProgram(', 'isRenderbuffer(', 'isShader(', 'isTexture(', 'lineWidth(', 'linkProgram(', 'pixelStorei(', 'polygonOffset(', 'readPixels(', 'renderbufferStorage(', 'sampleCoverage(', 'scissor(', 'shaderSource(', 'stencilFunc(', 'stencilFuncSeparate(', 'stencilMask(', 'stencilMaskSeparate(', 'stencilOp(', 'stencilOpSeparate(', 'texImage2D(', 'texParameterf(', 'texParameteri(', 'texSubImage2D(', 'uniform1f(', 'uniform1fv(', 'uniform1i(', 'uniform1iv(', 'uniform2f(', 'uniform2fv(', 'uniform2i(', 'uniform2iv(', 'uniform3f(', 'uniform3fv(', 'uniform3i(', 'uniform3iv(', 'uniform4f(', 'uniform4fv(', 'uniform4i(', 'uniform4iv(', 'uniformMatrix2fv(', 'uniformMatrix3fv(', 'uniformMatrix4fv(', 'useProgram(', 'validateProgram(', 'vertexAttrib1f(', 'vertexAttrib1fv(', 'vertexAttrib2f(', 'vertexAttrib2fv(', 'vertexAttrib3f(', 'vertexAttrib3fv(', 'vertexAttrib4f(', 'vertexAttrib4fv(', 'vertexAttribPointer(', 'viewport(']

let s:ctxs = ['arc(', 'arcTo(', 'beginPath(', 'bezierCurveTo(', 'canvas', 'clearRect(', 'clearShadow(', 'clip(', 'closePath(', 'constructor(', 'createImageData(', 'createLinearGradient(', 'createPattern(', 'createRadialGradient(', 'drawFocusIfNeeded(', 'drawImage(', 'drawImageFromRect(', 'ellipse(', 'fill(', 'fillRect(', 'fillStyle', 'fillText(', 'font', 'getContextAttributes(', 'getImageData(', 'getLineDash(', 'globalAlpha', 'globalCompositeOperation', 'imageSmoothingEnabled', 'isPointInPath(', 'isPointInStroke(', 'lineCap', 'lineDashOffset', 'lineJoin', 'lineTo(', 'lineWidth', 'measureText(', 'miterLimit', 'moveTo(', 'putImageData(', 'quadraticCurveTo(', 'rect(', 'resetTransform(', 'restore(', 'rotate(', 'save(', 'scale(', 'setAlpha(', 'setCompositeOperation(', 'setFillColor(', 'setLineCap(', 'setLineDash(', 'setLineJoin(', 'setLineWidth(', 'setMiterLimit(', 'setShadow(', 'setStrokeColor(', 'setTransform(', 'shadowBlur', 'shadowColor', 'shadowOffsetX', 'shadowOffsetY', 'stroke(', 'strokeRect(', 'strokeStyle', 'strokeText(', 'textAlign', 'textBaseline', 'toString(', 'transform(', 'translate(', 'webkitImageSmoothingEnabled']

let s:storage = ['clear(', 'constructor(', 'getItem(', 'key(', 'length', 'removeItem(', 'setItem(', 'toString(']

let s:bodys = ['ALLOW_KEYBOARD_INPUT', 'ATTRIBUTE_NODE', 'CDATA_SECTION_NODE', 'COMMENT_NODE', 'DOCUMENT_FRAGMENT_NODE', 'DOCUMENT_NODE', 'DOCUMENT_POSITION_CONTAINED_BY', 'DOCUMENT_POSITION_CONTAINS', 'DOCUMENT_POSITION_DISCONNECTED', 'DOCUMENT_POSITION_FOLLOWING', 'DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC', 'DOCUMENT_POSITION_PRECEDING', 'DOCUMENT_TYPE_NODE', 'ELEMENT_NODE', 'ENTITY_NODE', 'ENTITY_REFERENCE_NODE', 'NOTATION_NODE', 'PROCESSING_INSTRUCTION_NODE', 'TEXT_NODE', 'aLink', 'accessKey', 'addEventListener(', 'animate(', 'appendChild(', 'attributes', 'background', 'baseURI', 'bgColor', 'blur(', 'childElementCount', 'childNodes', 'children', 'classList', 'className', 'click(', 'clientHeight', 'clientLeft', 'clientTop', 'clientWidth', 'cloneNode(', 'compareDocumentPosition(', 'contains(', 'contentEditable', 'createShadowRoot(', 'dataset', 'dir', 'dispatchEvent(', 'draggable', 'firstChild', 'firstElementChild', 'focus(', 'getAttribute(', 'getAttributeNS(', 'getAttributeNode(', 'getAttributeNodeNS(', 'getBoundingClientRect(', 'getClientRects(', 'getDestinationInsertionPoints(', 'getElementsByClassName(', 'getElementsByTagName(', 'getElementsByTagNameNS(', 'hasAttribute(', 'hasAttributeNS(', 'hasAttributes(', 'hasChildNodes(', 'hidden', 'id', 'innerHTML', 'innerText', 'insertAdjacentElement(', 'insertAdjacentHTML(', 'insertAdjacentText(', 'insertBefore(', 'isContentEditable', 'isDefaultNamespace(', 'isEqualNode(', 'isSameNode(', 'lang', 'lastChild', 'lastElementChild', 'link', 'localName', 'lookupNamespaceURI(', 'lookupPrefix(', 'matches(', 'namespaceURI', 'nextElementSibling', 'nextSibling', 'nodeName', 'nodeType', 'nodeValue', 'normalize(', 'offsetHeight', 'offsetLeft', 'offsetParent', 'offsetTop', 'offsetWidth', 'onabort', 'onautocomplete', 'onautocompleteerror', 'onbeforecopy', 'onbeforecut', 'onbeforepaste', 'onbeforeunload', 'onblur', 'oncancel', 'oncanplay', 'oncanplaythrough', 'onchange', 'onclick', 'onclose', 'oncontextmenu', 'oncopy', 'oncuechange', 'oncut', 'ondblclick', 'ondrag', 'ondragend', 'ondragenter', 'ondragleave', 'ondragover', 'ondragstart', 'ondrop', 'ondurationchange', 'onemptied', 'onended', 'onerror', 'onfocus', 'onhashchange', 'oninput', 'oninvalid', 'onkeydown', 'onkeypress', 'onkeyup', 'onlanguagechange', 'onload', 'onloadeddata', 'onloadedmetadata', 'onloadstart', 'onmessage', 'onmousedown', 'onmouseenter', 'onmouseleave', 'onmousemove', 'onmouseout', 'onmouseover', 'onmouseup', 'onmousewheel', 'onoffline', 'ononline', 'onpagehide', 'onpageshow', 'onpaste', 'onpause', 'onplay', 'onplaying', 'onpopstate', 'onprogress', 'onratechange', 'onreset', 'onresize', 'onscroll', 'onsearch', 'onseeked', 'onseeking', 'onselect', 'onselectstart', 'onshow', 'onstalled', 'onstorage', 'onsubmit', 'onsuspend', 'ontimeupdate', 'ontoggle', 'onunload', 'onvolumechange', 'onwaiting', 'onwebkitfullscreenchange', 'onwebkitfullscreenerror', 'onwheel', 'outerHTML', 'outerText', 'ownerDocument', 'parentElement', 'parentNode', 'prefix', 'previousElementSibling', 'previousSibling', 'querySelector(', 'querySelectorAll(', 'remove(', 'removeAttribute(', 'removeAttributeNS(', 'removeAttributeNode(', 'removeChild(', 'removeEventListener(', 'replaceChild(', 'requestPointerLock(', 'scrollByLines(', 'scrollByPages(', 'scrollHeight', 'scrollIntoView(', 'scrollIntoViewIfNeeded(', 'scrollLeft', 'scrollTop', 'scrollWidth', 'setAttribute(', 'setAttributeNS(', 'setAttributeNode(', 'setAttributeNodeNS(', 'shadowRoot', 'spellcheck', 'style', 'tabIndex', 'tagName', 'text', 'textContent', 'title', 'translate', 'vLink', 'webkitMatchesSelector(', 'webkitRequestFullScreen(', 'webkitRequestFullscreen(', 'webkitRequestPointerLock(', 'webkitdropzone']

let s:docus = ['ATTRIBUTE_NODE', 'CDATA_SECTION_NODE', 'COMMENT_NODE', 'DOCUMENT_FRAGMENT_NODE', 'DOCUMENT_NODE', 'DOCUMENT_POSITION_CONTAINED_BY', 'DOCUMENT_POSITION_CONTAINS', 'DOCUMENT_POSITION_DISCONNECTED', 'DOCUMENT_POSITION_FOLLOWING', 'DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC', 'DOCUMENT_POSITION_PRECEDING', 'DOCUMENT_TYPE_NODE', 'ELEMENT_NODE', 'ENTITY_NODE', 'ENTITY_REFERENCE_NODE', 'NOTATION_NODE', 'PROCESSING_INSTRUCTION_NODE', 'TEXT_NODE', 'URL', 'activeElement', 'addEventListener(', 'adoptNode(', 'alinkColor', 'all', 'anchors', 'appendChild(', 'applets', 'baseURI', 'bgColor', 'body', 'captureEvents(', 'caretRangeFromPoint(', 'characterSet', 'charset', 'childElementCount', 'childNodes', 'children', 'clear(', 'cloneNode(', 'close(', 'compareDocumentPosition(', 'compatMode', 'contains(', 'contentType', 'cookie', 'createAttribute(', 'createAttributeNS(', 'createCDATASection(', 'createComment(', 'createDocumentFragment(', 'createElement(', 'createElementNS(', 'createEvent(', 'createExpression(', 'createNSResolver(', 'createNodeIterator(', 'createProcessingInstruction(', 'createRange(', 'createTextNode(', 'createTreeWalker(', 'currentScript', 'defaultView', 'designMode', 'dir', 'dispatchEvent(', 'doctype', 'documentElement', 'documentURI', 'domain', 'elementFromPoint(', 'elementsFromPoint(', 'embeds', 'evaluate(', 'execCommand(', 'exitPointerLock(', 'fgColor', 'firstChild', 'firstElementChild', 'fonts', 'forms', 'getElementById(', 'getElementsByClassName(', 'getElementsByName(', 'getElementsByTagName(', 'getElementsByTagNameNS(', 'getSelection(', 'hasChildNodes(', 'hasFocus(', 'head', 'hidden', 'images', 'implementation', 'importNode(', 'inputEncoding', 'insertBefore(', 'isConnected', 'isDefaultNamespace(', 'isEqualNode(', 'isSameNode(', 'lastChild', 'lastElementChild', 'lastModified', 'linkColor', 'links', 'location', 'lookupNamespaceURI(', 'lookupPrefix(', 'nextSibling', 'nodeName', 'nodeType', 'nodeValue', 'normalize(', 'onabort', 'onbeforecopy', 'onbeforecut', 'onbeforepaste', 'onblur', 'oncancel', 'oncanplay', 'oncanplaythrough', 'onchange', 'onclick', 'onclose', 'oncontextmenu', 'oncopy', 'oncuechange', 'oncut', 'ondblclick', 'ondrag', 'ondragend', 'ondragenter', 'ondragleave', 'ondragover', 'ondragstart', 'ondrop', 'ondurationchange', 'onemptied', 'onended', 'onerror', 'onfocus', 'oninput', 'oninvalid', 'onkeydown', 'onkeypress', 'onkeyup', 'onload', 'onloadeddata', 'onloadedmetadata', 'onloadstart', 'onmousedown', 'onmouseenter', 'onmouseleave', 'onmousemove', 'onmouseout', 'onmouseover', 'onmouseup', 'onmousewheel', 'onpaste', 'onpause', 'onplay', 'onplaying', 'onpointerlockchange', 'onpointerlockerror', 'onprogress', 'onratechange', 'onreadystatechange', 'onreset', 'onresize', 'onscroll', 'onsearch', 'onseeked', 'onseeking', 'onselect', 'onselectionchange', 'onselectstart', 'onshow', 'onstalled', 'onsubmit', 'onsuspend', 'ontimeupdate', 'ontoggle', 'onvolumechange', 'onwaiting', 'onwebkitfullscreenchange', 'onwebkitfullscreenerror', 'onwheel', 'open(', 'origin', 'ownerDocument', 'parentElement', 'parentNode', 'plugins', 'pointerLockElement', 'preferredStylesheetSet', 'previousSibling', 'queryCommandEnabled(', 'queryCommandIndeterm(', 'queryCommandState(', 'queryCommandSupported(', 'queryCommandValue(', 'querySelector(', 'querySelectorAll(', 'readyState', 'referrer', 'registerElement(', 'releaseEvents(', 'removeChild(', 'removeEventListener(', 'replaceChild(', 'rootElement', 'scripts', 'scrollingElement', 'selectedStylesheetSet', 'styleSheets', 'textContent', 'title', 'visibilityState', 'vlinkColor', 'webkitCancelFullScreen(', 'webkitCurrentFullScreenElement', 'webkitExitFullscreen(', 'webkitFullscreenElement', 'webkitFullscreenEnabled', 'webkitHidden', 'webkitIsFullScreen', 'webkitVisibilityState', 'write(', 'writeln(', 'xmlEncoding', 'xmlStandalone', 'xmlVersion']

let s:hists = ['back(', 'constructor(', 'forward(', 'go(', 'length', 'pushState(', 'replaceState(', 'toString(']

let s:imags = ['ALLOW_KEYBOARD_INPUT', 'ATTRIBUTE_NODE', 'CDATA_SECTION_NODE', 'COMMENT_NODE', 'DOCUMENT_FRAGMENT_NODE', 'DOCUMENT_NODE', 'DOCUMENT_POSITION_CONTAINED_BY', 'DOCUMENT_POSITION_CONTAINS', 'DOCUMENT_POSITION_DISCONNECTED', 'DOCUMENT_POSITION_FOLLOWING', 'DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC', 'DOCUMENT_POSITION_PRECEDING', 'DOCUMENT_TYPE_NODE', 'ELEMENT_NODE', 'ENTITY_NODE', 'ENTITY_REFERENCE_NODE', 'NOTATION_NODE', 'PROCESSING_INSTRUCTION_NODE', 'TEXT_NODE', 'accessKey', 'addEventListener(', 'align', 'alt', 'animate(', 'appendChild(', 'attributes', 'baseURI', 'blur(', 'border', 'childElementCount', 'childNodes', 'children', 'classList', 'className', 'click(', 'clientHeight', 'clientLeft', 'clientTop', 'clientWidth', 'cloneNode(', 'compareDocumentPosition(', 'complete', 'constructor(', 'contains(', 'contentEditable', 'createShadowRoot(', 'crossOrigin', 'dataset', 'dir', 'dispatchEvent(', 'draggable', 'firstChild', 'firstElementChild', 'focus(', 'getAttribute(', 'getAttributeNS(', 'getAttributeNode(', 'getAttributeNodeNS(', 'getBoundingClientRect(', 'getClientRects(', 'getDestinationInsertionPoints(', 'getElementsByClassName(', 'getElementsByTagName(', 'getElementsByTagNameNS(', 'hasAttribute(', 'hasAttributeNS(', 'hasAttributes(', 'hasChildNodes(', 'height', 'hidden', 'hspace', 'id', 'innerHTML', 'innerText', 'insertAdjacentElement(', 'insertAdjacentHTML(', 'insertAdjacentText(', 'insertBefore(', 'isContentEditable', 'isDefaultNamespace(', 'isEqualNode(', 'isMap', 'isSameNode(', 'lang', 'lastChild', 'lastElementChild', 'localName', 'longDesc', 'lookupNamespaceURI(', 'lookupPrefix(', 'lowsrc', 'matches(', 'namespaceURI', 'naturalHeight', 'naturalWidth', 'nextElementSibling', 'nextSibling', 'nodeName', 'nodeType', 'nodeValue', 'normalize(', 'offsetHeight', 'offsetLeft', 'offsetParent', 'offsetTop', 'offsetWidth', 'onabort', 'onautocomplete', 'onautocompleteerror', 'onbeforecopy', 'onbeforecut', 'onbeforepaste', 'onblur', 'oncancel', 'oncanplay', 'oncanplaythrough', 'onchange', 'onclick', 'onclose', 'oncontextmenu', 'oncopy', 'oncuechange', 'oncut', 'ondblclick', 'ondrag', 'ondragend', 'ondragenter', 'ondragleave', 'ondragover', 'ondragstart', 'ondrop', 'ondurationchange', 'onemptied', 'onended', 'onerror', 'onfocus', 'oninput', 'oninvalid', 'onkeydown', 'onkeypress', 'onkeyup', 'onload', 'onloadeddata', 'onloadedmetadata', 'onloadstart', 'onmousedown', 'onmouseenter', 'onmouseleave', 'onmousemove', 'onmouseout', 'onmouseover', 'onmouseup', 'onmousewheel', 'onpaste', 'onpause', 'onplay', 'onplaying', 'onprogress', 'onratechange', 'onreset', 'onresize', 'onscroll', 'onsearch', 'onseeked', 'onseeking', 'onselect', 'onselectstart', 'onshow', 'onstalled', 'onsubmit', 'onsuspend', 'ontimeupdate', 'ontoggle', 'onvolumechange', 'onwaiting', 'onwebkitfullscreenchange', 'onwebkitfullscreenerror', 'onwheel', 'outerHTML', 'outerText', 'ownerDocument', 'parentElement', 'parentNode', 'prefix', 'previousElementSibling', 'previousSibling', 'querySelector(', 'querySelectorAll(', 'remove(', 'removeAttribute(', 'removeAttributeNS(', 'removeAttributeNode(', 'removeChild(', 'removeEventListener(', 'replaceChild(', 'requestPointerLock(', 'scrollByLines(', 'scrollByPages(', 'scrollHeight', 'scrollIntoView(', 'scrollIntoViewIfNeeded(', 'scrollLeft', 'scrollTop', 'scrollWidth', 'setAttribute(', 'setAttributeNS(', 'setAttributeNode(', 'setAttributeNodeNS(', 'shadowRoot', 'spellcheck', 'src', 'srcset', 'style', 'tabIndex', 'tagName', 'textContent', 'title', 'translate', 'useMap', 'vspace', 'webkitMatchesSelector(', 'webkitRequestFullScreen(', 'webkitRequestFullscreen(', 'webkitRequestPointerLock(', 'webkitdropzone', 'width', 'x', 'y']

let s:navis = ['appCodeName', 'appName', 'appVersion', 'constructor(', 'cookieEnabled', 'doNotTrack', 'geolocation', 'getGamepads(', 'getMediaDevices(', 'getStorageUpdates(', 'hardwareConcurrency', 'javaEnabled(', 'language', 'languages', 'length', 'maxTouchPoints', 'mimeTypes', 'onLine', 'platform', 'plugins', 'product', 'productSub', 'registerProtocolHandler(', 'toString(', 'userAgent', 'vendor', 'vendorSub', 'vibrate(', 'webkitGetGamepads(', 'webkitGetUserMedia(', 'webkitPersistentStorage', 'webkitTemporaryStorage']

let s:scres = ['availHeight', 'availLeft', 'availTop', 'availWidth', 'colorDepth', 'constructor(', 'height', 'pixelDepth', 'toString(', 'width']

let s:styls = ['alignContent', 'alignItems', 'alignSelf', 'alignmentBaseline', 'all', 'animation', 'animationDelay', 'animationDirection', 'animationDuration', 'animationFillMode', 'animationIterationCount', 'animationName', 'animationPlayState', 'animationTimingFunction', 'backfaceVisibility', 'background', 'backgroundAttachment', 'backgroundBlendMode', 'backgroundClip', 'backgroundColor', 'backgroundImage', 'backgroundOrigin', 'backgroundPosition', 'backgroundPositionX', 'backgroundPositionY', 'backgroundRepeat', 'backgroundRepeatX', 'backgroundRepeatY', 'backgroundSize', 'baselineShift', 'border', 'borderBottom', 'borderBottomColor', 'borderBottomLeftRadius', 'borderBottomRightRadius', 'borderBottomStyle', 'borderBottomWidth', 'borderCollapse', 'borderColor', 'borderImage', 'borderImageOutset', 'borderImageRepeat', 'borderImageSlice', 'borderImageSource', 'borderImageWidth', 'borderLeft', 'borderLeftColor', 'borderLeftStyle', 'borderLeftWidth', 'borderRadius', 'borderRight', 'borderRightColor', 'borderRightStyle', 'borderRightWidth', 'borderSpacing', 'borderStyle', 'borderTop', 'borderTopColor', 'borderTopLeftRadius', 'borderTopRightRadius', 'borderTopStyle', 'borderTopWidth', 'borderWidth', 'bottom', 'boxShadow', 'boxSizing', 'breakAfter', 'breakBefore', 'breakInside', 'bufferedRendering', 'captionSide', 'clear', 'clip', 'clipPath', 'clipRule', 'color', 'colorInterpolation', 'colorInterpolationFilters', 'colorRendering', 'columnCount', 'columnFill', 'columnGap', 'columnRule', 'columnRuleColor', 'columnRuleStyle', 'columnRuleWidth', 'columnSpan', 'columnWidth', 'columns', 'contain', 'content', 'counterIncrement', 'counterReset', 'cssFloat', 'cssText', 'cursor', 'cx', 'cy', 'd', 'direction', 'display', 'dominantBaseline', 'emptyCells', 'fill', 'fillOpacity', 'fillRule', 'filter', 'flex', 'flexBasis', 'flexDirection', 'flexFlow', 'flexGrow', 'flexShrink', 'flexWrap', 'float', 'floodColor', 'floodOpacity', 'font', 'fontFamily', 'fontFeatureSettings', 'fontKerning', 'fontSize', 'fontStretch', 'fontStyle', 'fontVariant', 'fontVariantCaps', 'fontVariantLigatures', 'fontVariantNumeric', 'fontWeight', 'getPropertyPriority(', 'getPropertyValue(', 'height', 'imageRendering', 'isolation', 'item(', 'justifyContent', 'left', 'length', 'letterSpacing', 'lightingColor', 'lineHeight', 'listStyle', 'listStyleImage', 'listStylePosition', 'listStyleType', 'margin', 'marginBottom', 'marginLeft', 'marginRight', 'marginTop', 'marker', 'markerEnd', 'markerMid', 'markerStart', 'mask', 'maskType', 'maxHeight', 'maxWidth', 'maxZoom', 'minHeight', 'minWidth', 'minZoom', 'mixBlendMode', 'motion', 'motionOffset', 'motionPath', 'motionRotation', 'objectFit', 'objectPosition', 'opacity', 'order', 'orientation', 'orphans', 'outline', 'outlineColor', 'outlineOffset', 'outlineStyle', 'outlineWidth', 'overflow', 'overflowWrap', 'overflowX', 'overflowY', 'padding', 'paddingBottom', 'paddingLeft', 'paddingRight', 'paddingTop', 'page', 'pageBreakAfter', 'pageBreakBefore', 'pageBreakInside', 'paintOrder', 'parentRule', 'perspective', 'perspectiveOrigin', 'pointerEvents', 'position', 'quotes', 'r', 'removeProperty(', 'resize', 'right', 'rx', 'ry', 'setProperty(', 'shapeImageThreshold', 'shapeMargin', 'shapeOutside', 'shapeRendering', 'size', 'speak', 'src', 'stopColor', 'stopOpacity', 'stroke', 'strokeDasharray', 'strokeDashoffset', 'strokeLinecap', 'strokeLinejoin', 'strokeMiterlimit', 'strokeOpacity', 'strokeWidth', 'tabSize', 'tableLayout', 'textAlign', 'textAlignLast', 'textAnchor', 'textCombineUpright', 'textDecoration', 'textIndent', 'textOrientation', 'textOverflow', 'textRendering', 'textShadow', 'textTransform', 'top', 'touchAction', 'transform', 'transformOrigin', 'transformStyle', 'transition', 'transitionDelay', 'transitionDuration', 'transitionProperty', 'transitionTimingFunction', 'unicodeBidi', 'unicodeRange', 'userZoom', 'vectorEffect', 'verticalAlign', 'visibility', 'webkitAppRegion', 'webkitAppearance', 'webkitBackgroundClip', 'webkitBackgroundOrigin', 'webkitBorderAfter', 'webkitBorderAfterColor', 'webkitBorderAfterStyle', 'webkitBorderAfterWidth', 'webkitBorderBefore', 'webkitBorderBeforeColor', 'webkitBorderBeforeStyle', 'webkitBorderBeforeWidth', 'webkitBorderEnd', 'webkitBorderEndColor', 'webkitBorderEndStyle', 'webkitBorderEndWidth', 'webkitBorderHorizontalSpacing', 'webkitBorderImage', 'webkitBorderStart', 'webkitBorderStartColor', 'webkitBorderStartStyle', 'webkitBorderStartWidth', 'webkitBorderVerticalSpacing', 'webkitBoxAlign', 'webkitBoxDecorationBreak', 'webkitBoxDirection', 'webkitBoxFlex', 'webkitBoxFlexGroup', 'webkitBoxLines', 'webkitBoxOrdinalGroup', 'webkitBoxOrient', 'webkitBoxPack', 'webkitBoxReflect', 'webkitClipPath', 'webkitColumnBreakAfter', 'webkitColumnBreakBefore', 'webkitColumnBreakInside', 'webkitFilter', 'webkitFontSizeDelta', 'webkitFontSmoothing', 'webkitHighlight', 'webkitHyphenateCharacter', 'webkitLineBreak', 'webkitLineClamp', 'webkitLocale', 'webkitLogicalHeight', 'webkitLogicalWidth', 'webkitMarginAfter', 'webkitMarginAfterCollapse', 'webkitMarginBefore', 'webkitMarginBeforeCollapse', 'webkitMarginBottomCollapse', 'webkitMarginCollapse', 'webkitMarginEnd', 'webkitMarginStart', 'webkitMarginTopCollapse', 'webkitMask', 'webkitMaskBoxImage', 'webkitMaskBoxImageOutset', 'webkitMaskBoxImageRepeat', 'webkitMaskBoxImageSlice', 'webkitMaskBoxImageSource', 'webkitMaskBoxImageWidth', 'webkitMaskClip', 'webkitMaskComposite', 'webkitMaskImage', 'webkitMaskOrigin', 'webkitMaskPosition', 'webkitMaskPositionX', 'webkitMaskPositionY', 'webkitMaskRepeat', 'webkitMaskRepeatX', 'webkitMaskRepeatY', 'webkitMaskSize', 'webkitMaxLogicalHeight', 'webkitMaxLogicalWidth', 'webkitMinLogicalHeight', 'webkitMinLogicalWidth', 'webkitPaddingAfter', 'webkitPaddingBefore', 'webkitPaddingEnd', 'webkitPaddingStart', 'webkitPerspectiveOriginX', 'webkitPerspectiveOriginY', 'webkitPrintColorAdjust', 'webkitRtlOrdering', 'webkitRubyPosition', 'webkitTapHighlightColor', 'webkitTextCombine', 'webkitTextDecorationsInEffect', 'webkitTextEmphasis', 'webkitTextEmphasisColor', 'webkitTextEmphasisPosition', 'webkitTextEmphasisStyle', 'webkitTextFillColor', 'webkitTextOrientation', 'webkitTextSecurity', 'webkitTextStroke', 'webkitTextStrokeColor', 'webkitTextStrokeWidth', 'webkitTransformOriginX', 'webkitTransformOriginY', 'webkitTransformOriginZ', 'webkitUserDrag', 'webkitUserModify', 'webkitUserSelect', 'webkitWritingMode', 'whiteSpace', 'widows', 'width', 'willChange', 'wordBreak', 'wordSpacing', 'wordWrap', 'writingMode', 'x', 'y', 'zIndex', 'zoom']

let s:niters = ['constructor(', 'detach(', 'expandEntityReferences', 'filter', 'length', 'nextNode(', 'pointerBeforeReferenceNode', 'previousNode(', 'referenceNode', 'root', 'toString(', 'whatToShow']

let s:nfilter = ['FILTER_ACCEPT', 'FILTER_REJECT', 'FILTER_SKIP', 'SHOW_ALL', 'SHOW_ATTRIBUTE', 'SHOW_CDATA_SECTION', 'SHOW_COMMENT', 'SHOW_DOCUMENT', 'SHOW_DOCUMENT_FRAGMENT', 'SHOW_DOCUMENT_TYPE', 'SHOW_ELEMENT', 'SHOW_ENTITY', 'SHOW_ENTITY_REFERENCE', 'SHOW_NOTATION', 'SHOW_PROCESSING_INSTRUCTION', 'SHOW_TEXT', 'acceptNode(', 'constructor(', 'length', 'toString(']

let s:twalkers = ['constructor(', 'currentNode', 'expandEntityReferences', 'filter', 'firstChild(', 'lastChild(', 'length', 'nextNode(', 'nextSibling(', 'parentNode(', 'previousNode(', 'previousSibling(', 'root', 'toString(', 'whatToShow']

let s:console = ['assert(', 'clear(', 'count(', 'debug(', 'dir(', 'dirxml(', 'error(', 'group(', 'groupCollapsed(', 'groupEnd(', 'info(', 'log(', 'markTimeline(', 'memory', 'profile(', 'profileEnd(', 'table(', 'time(', 'timeEnd(', 'timeStamp(', 'timeline(', 'timelineEnd(', 'trace(', 'warn(']

let s:xmlhs = ['DONE', 'HEADERS_RECEIVED', 'LOADING', 'OPENED', 'UNSENT', 'abort(', 'addEventListener(', 'constructor(', 'dispatchEvent(', 'getAllResponseHeaders(', 'getResponseHeader(', 'length', 'onabort', 'onerror', 'onload', 'onloadend', 'onloadstart', 'onprogress', 'onreadystatechange', 'ontimeout', 'open(', 'overrideMimeType(', 'readyState', 'removeEventListener(', 'response', 'responseText', 'responseType', 'responseURL', 'responseXML', 'send(', 'setRequestHeader(', 'status', 'statusText', 'timeout', 'toString(', 'upload', 'withCredentials']

function! javascriptcomplete#CompleteJS(findstart, base)
  if a:findstart
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    let curline = line('.')
    let compl_begin = col('.') - 2
    " Bit risky but JS is rather limited language and local chars shouldn't
    " fint way into names
    while start >= 0 && line[start - 1] =~ '\k'
      let start -= 1
    endwhile
    let b:compl_context = getline('.')[0:compl_begin]
    return start
  else
    " Initialize base return lists
    let res = []
    let res2 = []
    " a:base is very short - we need context
    " Shortcontext is context without a:base, useful for checking if we are
    " looking for objects and for what objects we are looking for
    let context = b:compl_context
    let shortcontext = substitute(context, a:base.'$', '', '')
    unlet! b:compl_context

    if exists("b:jsrange")
      let file = getline(b:jsrange[0],b:jsrange[1])
      unlet! b:jsrange

      if len(b:js_extfiles) > 0
        let file = b:js_extfiles + file
      endif

    else
      let file = getline(1, '$')
    endif


    if shortcontext =~ '\.$'

      let user_props1 = filter(copy(file), 'v:val =~ "this\\.\\k"')
      let juser_props1 = join(user_props1, ' ')
      let user_props1 = split(juser_props1, '\zethis\.')
      unlet! juser_props1
      call map(user_props1, 'matchstr(v:val, "this\\.\\zs\\k\\+\\ze")')

      let user_props2 = filter(copy(file), 'v:val =~ "\\.prototype\\.\\k"')
      let juser_props2 = join(user_props2, ' ')
      let user_props2 = split(juser_props2, '\zeprototype\.')
      unlet! juser_props2
      call map(user_props2, 'matchstr(v:val, "prototype\\.\\zs\\k\\+\\ze")')
      let user_props = user_props1 + user_props2

      " Find object type declaration to reduce number of suggestions. {{{
      " 1. Get object name
      " 2. Find object declaration line
      " 3. General declaration follows "= new Type" syntax, additional else
      "    for regexp "= /re/"
      " 4. Make correction for Microsoft.XMLHTTP ActiveXObject
      " 5. Repeat for external files
      let object = matchstr(shortcontext, '\zs\k\+\ze\(\[.\{-}\]\)\?\.$')
      if len(object) > 0
        let decl_line = search(object.'.\{-}=\s*new\s*', 'bn')
        if decl_line > 0
          let object_type = matchstr(getline(decl_line), object.'.\{-}=\s*new\s*\zs\k\+\ze')
          if object_type == 'ActiveXObject' && matchstr(getline(decl_line), object.'.\{-}=\s*new\s*ActiveXObject\s*(.Microsoft\.XMLHTTP.)') != ''
            let object_type = 'XMLHttpRequest'
          endif
        else
          if search(object.'\s*=\s*\/', 'bn') > 0
            let object_type = 'RegExp'
          elseif search(object.'\s*=\s*{', 'bn') > 0
            let object_type = 'Object'
          elseif search(object.'\s*=\s*\(true\|false\|!\)', 'bn') > 0
            let object_type = 'Boolean'
          elseif search(object.'\s*=\s*\[', 'bn') > 0
            let object_type = 'Array'
          elseif search(object.'\s*=\s*\(["'."'".']\|String(\)', 'bn') > 0
            let object_type = 'String'
          elseif search(object.'\s*=\s*document\.createTreeWalker(', 'bn') > 0
            let object_type = 'TreeWalker'
          elseif search(object.'\s*=\s*[a-zA-Z_$]\+\.getContext( *.webgl', 'bn') > 0
            let object_type = 'WebGL'
          elseif search(object.'\s*=\s*[a-zA-Z_$]\+\.getContext( *.2d', 'bn') > 0
            let object_type = 'CanvasRenderingContext2D'
          elseif search(object.'\s*=\s*document\.createNodeIterator(', 'bn') > 0
            let object_type = 'NodeIterator'
          endif
        endif
        " We didn't find var declaration in current file but we may have
        " something in external files.
        if decl_line == 0 && exists("b:js_extfiles")
          let dext_line = filter(copy(b:js_extfiles), 'v:val =~ "'.object.'.\\{-}=\\s*new\\s*"')
          if len(dext_line) > 0
            let object_type = matchstr(dext_line[-1], object.'.\{-}=\s*new\s*\zs\k\+\ze')
            if object_type == 'ActiveXObject' && matchstr(dext_line[-1], object.'.\{-}=\s*new\s*ActiveXObject\s*(.Microsoft\.XMLHTTP.)') != ''
              let object_type = 'XMLHttpRequest'
            endif
          else
            let dext_line = filter(copy(b:js_extfiles), 'v:val =~ "var\s*'.object.'\\s*=\\s*\\/"')
            if len(dext_line) > 0
              let object_type = 'RegExp'
            endif
          endif
        endif
      endif

      if !exists('object_type')
        let object_type = ''
      endif

      if object_type == 'Date'
        let values = s:dates
      elseif object_type == 'Image'
        let values = s:imags
      elseif object_type == 'Array'
        let values = s:arrays
      elseif object_type == 'Object'
        let values = s:objes
      elseif object_type == 'Boolean'
        let values = ['constructor', 'toString', 'valueOf']
      elseif object_type == 'XMLHttpRequest'
        let values = s:xmlhs
      elseif object_type == 'String'
        let values = s:stris
      elseif object_type == 'RegExp'
        let values = s:reges
      elseif object_type == 'Math'
        let values = s:maths
      elseif object_type == 'WebGL'
        let values = s:webgl
      elseif object_type == 'CanvasRenderingContext2D'
        let values = s:ctxs
      elseif object_type == 'NodeIterator'
        let values = s:niters
      elseif object_type == 'TreeWalker'
        let values = s:twalkers
      endif

      "Chrome extension API completions -- enable with 'let g:vimjs#chromeapis = 1'
      if !exists('values') && g:vimjs#chromeapis == 1
        if shortcontext =~ 'chrome\.$'
          let values = s:chromeo
        elseif shortcontext =~ 'chrome\.\([a-zA-Z]\+\.\)\+$'
          if shortcontext =~ 'tabs\.$'
            let values = s:chrometabs
          elseif shortcontext =~ 'history\.$'
            let values = s:chromehist
          elseif shortcontext =~ 'bookmarks\.$'
            let values = s:chromemarks
          elseif shortcontext =~ 'command\.$'
            let values = s:chromecomm
          elseif shortcontext =~ 'windows\.$'
            let values = s:chromewins
          elseif shortcontext =~ 'extension\.$'
            let values = s:chromeext
          elseif shortcontext =~ 'runtime\.$'
            let values = s:chromerunt
          elseif shortcontext =~ 'topSites\.$'
            let values = s:chrometops
          elseif shortcontext =~ 'browserAction\.$'
            let values = s:chromebact
          elseif shortcontext =~ 'app\.$'
            let values = s:chromeapp
          elseif shortcontext =~ 'downloads\.$'
            let values = s:chromedown
          elseif shortcontext =~ 'management\.$'
            let values = s:chromeman
          elseif shortcontext =~ 'permissions\.$'
            let values = s:chromeperm
          elseif shortcontext =~ 'sessions\.$'
            let values = s:chromesess
          elseif shortcontext =~ 'storage\.$'
            let values = s:chromestor
          elseif shortcontext =~ 'storage\.sync\.$'
            let values = s:chromestorsync
          elseif shortcontext =~ 'storage\.local\.$'
            let values = s:chromestorloc
          elseif shortcontext =~ '\.on[A-Z][a-z]\+\.$'
            let values = ['addListener(', 'addRules(', 'dispatch(', 'dispatchToListener(', 'getRules(', 'hasListener(', 'hasListeners(', 'removeListener(', 'removeRules(']
          endif
        endif
      endif

      if !exists('values')
        if shortcontext =~ 'Math\.$'
          let values = s:maths
        elseif shortcontext =~ 'body\.$'
          let values = s:bodys
        elseif shortcontext =~ 'document\.$'
          let values = s:docus
        elseif shortcontext =~ 'history\.$'
          let values = s:hists
        elseif shortcontext =~ 'JSON\.$'
          let values = ['parse(', 'stringify(']
        elseif shortcontext =~ '\(local\|session\)Storage\.$'
          let values = s:storage
        elseif shortcontext =~ 'NodeFilter\.$'
          let values = s:nfilter
        elseif shortcontext =~ '\/.*\(\\\/\)\@!\/\.$'
          let values = s:reges
        elseif shortcontext =~ 'images\(\[.\{-}\]\)\?\.$'
          let values = s:imags
        elseif shortcontext =~ 'location\.$'
          let values = s:locas
        elseif shortcontext =~ 'navigator\.$'
          let values = s:navis
        elseif shortcontext =~ 'console\.$'
          let values = s:console
        elseif shortcontext =~ 'event\.$'
          let values = s:evnts
        elseif shortcontext =~ '\]\.$'
          let values = s:arrays
        elseif shortcontext =~ "['\"]\.$"
          let values = s:stris
        elseif shortcontext =~ '\(}\|object\)\.$'
          let values = s:objes
        elseif shortcontext =~ 'screen\.$'
          let values = s:scres
        elseif shortcontext =~ 'style\.$'
          let values = s:styls
        elseif shortcontext =~ '\(top\|self\|window\)\.$'
          let values = s:winds
        else
          let values = user_props + s:bodys + s:arrays + s:dates +
                \ s:funcs + s:numbs + s:reges + s:stris + s:docus +
                \ s:imags + s:locas + s:navis + s:objes + s:scres + s:winds
        endif
      endif

      let oprops1 = matchstr(shortcontext, '\zs\k\+\ze\(\[.\{-}\]\)\?\.$')
      let oprops = []
      if len(oprops1) > 0
        let oprops = filter(copy(file), 'v:val =~ "'.oprops1.'\\.[a-zA-Z_]\\+\\s*="')
        call map(oprops, 'matchstr(v:val, "\\.\\zs[a-zA-Z_]\\+\\ze")')
        let oprops2 = filter(copy(file), 'v:val =~ "\\w*\\(case\\|default\\)\\@!:"')
        call map(oprops2, 'matchstr(v:val, "\\zs\\w\\+\\ze:")')
        let values = oprops + oprops2 + values
      endif

      for m in values
        if m =~? '^'.a:base
          call add(res, m)
        elseif m =~? a:base
          call add(res2, m)
        endif
      endfor

      unlet! values
      return res + res2

    endif

    let variables = filter(copy(file), 'v:val =~ "var\\s"')
    call map(variables, 'matchstr(v:val, ".\\{-}var\\s\\+\\zs.*\\ze")')
    call map(variables, 'substitute(v:val, ";\\|$", ",", "g")')
    let vars = []
    " This loop (and next one) is necessary to get variable names from
    " constructs like: var var1, var2, var3 = "something";
    for i in range(len(variables))
      let comma_separated = split(variables[i], ',\s*')
      call map(comma_separated, 'matchstr(v:val, "\\k\\+")')
      let vars += comma_separated
    endfor

    let variables = sort(vars)
    unlet! vars

    " Add "no var" variables.
    let undeclared_variables = filter(copy(file), 'v:val =~ "^\\s*\\k\\+\\s*="')
    let u_vars = []
    for i in range(len(undeclared_variables))
      let  split_equal = split(undeclared_variables[i], '\s*=')
      call map(split_equal, 'matchstr(v:val, "\\k\\+$")')
      let u_vars += split_equal
    endfor

    let variables += sort(u_vars)
    unlet! u_vars

    " Get functions
    let functions = filter(copy(file), 'v:val =~ "^\\s*function\\s"')
    let arguments = copy(functions)
    call map(functions, 'matchstr(v:val, "^\\s*function\\s\\+\\zs\\k\\+")')
    call map(functions, 'v:val."("')
    let functions = sort(functions)

    " Create table to keep arguments for additional 'menu' info
    let b:js_menuinfo = {}
    for i in arguments
      let g:ia = i
      let f_elements = matchlist(i, 'function\s\+\(\k\+\)\s*(\(.\{-}\))')
      if len(f_elements) == 3
        let b:js_menuinfo[f_elements[1].'('] = f_elements[2]
      endif
    endfor

    call map(arguments, 'matchstr(v:val, "function.\\{-}(\\zs.\\{-}\\ze)")')
    let jargs = join(arguments, ',')
    let jargs = substitute(jargs, '\s', '', 'g')
    let arguments = split(jargs, ',')
    let arguments = sort(arguments)

    let values = variables + functions + arguments + s:keywords + s:winds

    for m in values
      let valueadded = 0
      if g:vimjs#casesensitive
        if m =~# '^'.a:base
          let valueadded = 1
        endif
      else
        if m =~? '^'.a:base
          let valueadded = 1
        endif
      endif
      if valueadded == 1 || (g:vimjs#smartcomplete == 1 && m =~ a:base)
        call add(res, m)
      endif
    endfor

    let menu = res + res2
    let final_menu = []
    for i in range(len(menu))
      let item = menu[i]
      if item =~ '($'
        let kind = '[F]'
        if has_key(b:js_menuinfo, item)
          let m_info = b:js_menuinfo[item]
        else
          let m_info = ''
        endif
      else
        let kind = '[V]'
        let m_info = ''
      endif
      let final_menu += [{'word':item, 'menu':m_info, 'kind':kind}]
    endfor
    let g:fm = final_menu
    return final_menu

endfunction
