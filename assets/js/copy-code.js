function addCopyButtonToCode(){
// get all code elements
var allCodeBlocksElements = $( "div.input pre" );

// For each element, do the following steps
allCodeBlocksElements.each(function(ii) {
// define a unique id for this element and add it
var currentId = "codeblock" + (ii + 1);
$(this).attr('id', currentId);

// create a button that's configured for clipboard.js
// point it to the text that's in this code block
// add the button just after the text in the code block w/ jquery
var clipButton = '<button class="btn copybtn" data-tooltip="Copy" title="Copy" data-clipboard-target="#' + currentId + '"><img src="/images/copy-button.svg" width="17" alt="Copy to clipboard"></button>';
   $(this).after(clipButton);
});

// tell clipboard.js to look for clicks that match this query
new Clipboard('.btn');
}

$(document).ready(function () {
// Once the DOM is loaded for the page, attach clipboard buttons
addCopyButtonToCode();
});

// i don't know enough about js to make this implement for this code
// the code below is for a sphinx site. ally might know?

const codeCellId = index => `codecell${index}`

// Clears selected text since ClipboardJS will select the text when copying
const clearSelection = () => {
  if (window.getSelection) {
    window.getSelection().removeAllRanges()
  } else if (document.selection) {
    document.selection.empty()
  }
}

// Changes tooltip text for two seconds, then changes it back
const temporarilyChangeTooltip = (el, newText) => {
  const oldText = el.getAttribute('data-tooltip')
  el.setAttribute('data-tooltip', newText)
  setTimeout(() => el.setAttribute('data-tooltip', oldText), 2000)
}

// to work on tooltips and colors
// https://earthlab-hub-ops.readthedocs.io/en/latest/_static/copybutton.js
