fnjvUrl = "https://www2.ib.unicamp.br/fnjv/"

soundCollectionLink = "css:a.z-link img[alt=Audio]"

spinner = "css:span.spinner"

searchTitle = "css:div#FnjvCollectionFilter.search-filter-container.accordion-fnjv div.accordion div.header"

searchBlock = "css:div#FnjvCollectionFilter.search-filter-container.accordion-fnjv div.accordion div.content"

phylumSelector = "css:#select2-animal-phylum-audio-container"

phylumSelectorResults = "css:span.select2-results"

chordataOption = "xpath:.//li[text()='Chordata']"

classSpinner = "css:div#loading-animal-class img"

classSelector = "css:span.select2-selection.select2-selection--single span#select2-animal-class-audio-container.select2-selection__rendered"

classSelectorResults = "css:span.select2-dropdown.select2-dropdown--below span.select2-results ul#select2-animal-class-audio-results.select2-results__options"

amphibiaOption = "xpath:.//li[text()='Amphibia']"

orderSpinner = "css:div#loading-animal-order img"

orderSelector = "css:span.select2-selection.select2-selection--single span#select2-animal-order-audio-container.select2-selection__rendered"

orderSelectorResults = "css:span.select2-dropdown.select2-dropdown--below span.select2-results ul#select2-animal-order-audio-results.select2-results__options"

anuraOption = "xpath:.//li[text()='Anura']"

searchButton = "css:button#LoadAudioRecordsButton.button-filter"

numberOfPages = "css:div.jtable-bottom-panel div.jtable-left-area span.jtable-page-list span.jtable-page-number:nth-child(7)"

nextPage = "css:div.jtable-bottom-panel div.jtable-left-area span.jtable-page-list span.jtable-page-number-next"

tableRow = "css:div#FnjvAudioCollection div.jtable-main-container table.jtable tbody tr.jtable-data-row"

audioButton = " td input[title='Tocar Áudio']"

noAudio = " td input[src='img/blank.png']"

individualDataPopup = "css:body.modal-open div#FnjvRecordModal.modal.fade.in"

individualDataPopupCloseButton = individualDataPopup+" div.modal-dialog div.modal-content div.modal-header button.close"

individualInfoHeader = individualDataPopup+" div.accordion:nth-child(1) div.header"

registerInfoHeader = individualDataPopup+" div.accordion:nth-child(2) div.header"

locationInfoHeader = individualDataPopup+" div.accordion:nth-child(3) div.header"

individualDataActiveContent = individualDataPopup+" div.accordion.active div.content"

individualSoundElement = individualDataPopup+" div.player_panel div.player_fnjv_record"

individualAudioElement = individualSoundElement+" audio"