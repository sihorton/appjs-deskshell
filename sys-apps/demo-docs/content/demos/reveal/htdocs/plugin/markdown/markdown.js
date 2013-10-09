/**
 * The reveal.js markdown plugin. Handles parsing of
 * markdown inside of presentations as well as loading
 * of external markdown documents.
 */
(function( root, factory ) {
	if( typeof exports === 'object' ) {
		module.exports = factory( require( './marked' ) );
	}
	else {
		// Browser globals (root is window)
		root.RevealMarkdown = factory( root.marked );
		root.RevealMarkdown.initialize();
	}
}( this, function( marked ) {

	if( typeof marked === 'undefined' ) {
		throw 'The reveal.js Markdown plugin requires marked to be loaded';
	}

	if( typeof hljs !== 'undefined' ) {
		marked.setOptions({
			highlight: function( lang, code ) {
				return hljs.highlightAuto( lang, code ).value;
			}
		});
	}

	var DEFAULT_SLIDE_SEPARATOR = '^\n---\n$',
		DEFAULT_NOTES_SEPARATOR = 'note:';


	/**
	 * Retrieves the markdown contents of a slide section
	 * element. Normalizes leading tabs/whitespace.
	 */
	function getMarkdownFromSlide( section ) {

		var template = section.querySelector( 'script' );

		// strip leading whitespace so it isn't evaluated as code
		var text = ( template || section ).textContent;

		var leadingWs = text.match( /^\n?(\s*)/ )[1].length,
			leadingTabs = text.match( /^\n?(\t*)/ )[1].length;

		if( leadingTabs > 0 ) {
			text = text.replace( new RegExp('\\n?\\t{' + leadingTabs + '}','g'), '\n' );
		}
		else if( leadingWs > 1 ) {
			text = text.replace( new RegExp('\\n? {' + leadingWs + '}','g'), '\n' );
		}

		return text;

	}

	/**
	 * Given a markdown slide section element, this will
	 * return all arguments that aren't related to markdown
	 * parsing. Used to forward any other user-defined arguments
	 * to the output markdown slide.
	 */
	function getForwardedAttributes( section ) {

		var attributes = section.attributes;
		var result = [];

		for( var i = 0, len = attributes.length; i < len; i++ ) {
			var name = attributes[i].name,
				value = attributes[i].value;

			// disregard attributes that are used for markdown loading/parsing
			if( /data\-(markdown|separator|vertical|notes)/gi.test( name ) ) continue;

			if( value ) {
				result.push( name + '=' + value );
			}
			else {
				result.push( name );
			}
		}

		return result.join( ' ' );

	}

	/**
	 * Inspects the given options and fills out default
	 * values for what's not defined.
	 */
	function getSlidifyOptions( options ) {

		options = options || {};
		options.separator = options.separator || DEFAULT_SLIDE_SEPARATOR;
		options.notesSeparator = options.notesSeparator || DEFAULT_NOTES_SEPARATOR;
		options.attributes = options.attributes || '';

		return options;

	}

	/**
	 * Helper function for constructing a markdown slide.
	 */
	function createMarkdownSlide( content, options ) {

		options = getSlidifyOptions( options );

		var notesMatch = content.split( new RegExp( options.notesSeparator, 'mgi' ) );

		if( notesMatch.length === 2 ) {
			content = notesMatch[0] + '<aside class="notes" data-markdown>' + notesMatch[1].trim() + '</aside>';
		}

		return '<script type="text/template">' + content + '</script>';

	}

	/**
	 * Parses a data string into multiple slides based
	 * on the passed in separator arguments.
	 */
	function slidify( markdown, options ) {

		options = getSlidifyOptions( options );

		var separatorRegex = new RegExp( options.separator + ( options.verticalSeparator ? '|' + options.verticalSeparator : '' ), 'mg' ),
			horizontalSeparatorRegex = new RegExp( options.separator );

		var matches,
			lastIndex = 0,
			isHorizontal,
			wasHorizontal = true,
			content,
			sectionStack = [];

		// iterate until all blocks between separators are stacked up
		while( matches = separatorRegex.exec( markdown ) ) {
			notes = null;

			// determine direction (horizontal by default)
			isHorizontal = horizontalSeparatorRegex.test( matches[0] );

			if( !isHorizontal && wasHorizontal ) {
				// create vertical stack
				sectionStack.push( [] );
			}

			// pluck slide content from markdown input
			content = markdown.substring( lastIndex, matches.index );

			if( isHorizontal && wasHorizontal ) {
				// add to horizontal stack
				sectionStack.push( content );
			}
			else {
				// add to vertical stack
				sectionStack[sectionStack.length-1].push( content );
			}

			lastIndex = separatorRegex.lastIndex;
			wasHorizontal = isHorizontal;
		}

		// add the remaining slide
		( wasHorizontal ? sectionStack : sectionStack[sectionStack.length-1] ).push( markdown.substring( lastIndex ) );

		var markdownSections = '';

		// flatten the hierarchical stack, and insert <section data-markdown> tags
		for( var i = 0, len = sectionStack.length; i < len; i++ ) {
			// vertical
			if( sectionStack[i].propertyIsEnumerable( length ) && typeof sectionStack[i].splice === 'function' ) {
				markdownSections += '<section '+ options.attributes +'>';

				sectionStack[i].forEach( function( child ) {
					markdownSections += '<section data-markdown>' +  createMarkdownSlide( child, options ) + '</section>';
				} );

				markdownSections += '</section>';
			}
			else {
				markdownSections += '<section '+ options.attributes +' data-markdown>' + createMarkdownSlide( sectionStack[i], options ) + '</section>';
			}
		}

		return markdownSections;

	}

	/**
	 * Parses any current data-markdown slides, splits
	 * multi-slide markdown into separate sections and
	 * handles loading of external markdown.
	 */
	function processSlides() {

		var sections = document.querySelectorAll( '[data-markdown]'),
			section;

		for( var i = 0, len = sections.length; i < len; i++ ) {

			section = sections[i];

			if( section.getAttribute( 'data-markdown' ).length ) {

				var xhr = new XMLHttpRequest(),
					url = section.getAttribute( 'data-markdown' );

				datacharset = section.getAttribute( 'data-charset' );

				// see https://developer.mozilla.org/en-US/docs/Web/API/element.getAttribute#Notes
				if( datacharset != null && datacharset != '' ) {
					xhr.overrideMimeType( 'text/html; charset=' + datacharset );
				}

				xhr.onreadystatechange = function() {
					if( xhr.readyState === 4 ) {
						if ( xhr.status >= 200 && xhr.status < 300 ) {

							section.outerHTML = slidify( xhr.responseText, {
								separator: section.getAttribute( 'data-separator' ),
								verticalSeparator: section.getAttribute( 'data-vertical' ),
								notesSeparator: section.getAttribute( 'data-notes' ),
								attributes: getForwardedAttributes( section )
							});

						}
						else {

							section.outerHTML = '<section data-state="alert">' +
								'ERROR: The attempt to fetch ' + url + ' failed with HTTP status ' + xhr.status + '.' +
								'Check your browser\'s JavaScript console for more details.' +
								'<p>Remember that you need to serve the presentation HTML from a HTTP server.</p>' +
								'</section>';

						}
					}
				};

				xhr.open( 'GET', url, false );

				try {
					xhr.send();
				}
				catch ( e ) {
					alert( 'Failed to get the Markdown file ' + url + '. Make sure that the presentation and the file are served by a HTTP server and the file can be found there. ' + e );
				}

			}
			else if( section.getAttribute( 'data-separator' ) || section.getAttribute( 'data-vertical' ) || section.getAttribute( 'data-notes' ) ) {

				section.outerHTML = slidify( getMarkdownFromSlide( section ), {
					separator: section.getAttribute( 'data-separator' ),
					verticalSeparator: section.getAttribute( 'data-vertical' ),
					notesSeparator: section.getAttribute( 'data-notes' ),
					attributes: getForwardedAttributes( section )
				});

			}
			else {

				section.innerHTML = createMarkdownSlide( getMarkdownFromSlide( section ) );

			}
		}

	}

	/**
	 * Converts any current data-markdown slides in the
	 * DOM to HTML.
	 */
	function convertSlides() {

		var sections = document.querySelectorAll( '[data-markdown]');

		for( var i = 0, len = sections.length; i < len; i++ ) {

			var section = sections[i];

			// Only parse the same slide once
			if( !section.getAttribute( 'data-markdown-parsed' ) ) {

				section.setAttribute( 'data-markdown-parsed', true )

				var notes = section.querySelector( 'aside.notes' );
				var markdown = getMarkdownFromSlide( section );

				section.innerHTML = marked( markdown );

				// If there were notes, we need to re-add them after
				// having overwritten the section's HTML
				if( notes ) {
					section.appendChild( notes );
				}

			}

		}

	}

	// API
	return {

		initialize: function() {
			processSlides();
			convertSlides();
		},

		// TODO: Do these belong in the API?
		processSlides: processSlides,
		convertSlides: convertSlides,
		slidify: slidify

	};

}));
