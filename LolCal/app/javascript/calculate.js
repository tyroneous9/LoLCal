/*-----Init-----*/
const ddragonBaseUrl = 'https://ddragon.leagueoflegends.com/cdn/14.4.1/img/item/';

document.addEventListener('DOMContentLoaded', function() {
    // Populate items table
    fetch('/items')
        .then(response => response.json())
        .then(items => {
            populateItemsTable(items);
        })
        .catch(error => console.error('Error fetching items', error));

    // Load build
    if (!sessionStorage.getItem('build')) {
        sessionStorage.setItem('build', JSON.stringify([]));
    }
    updateBuild();

    // Buttons
    document.getElementById('add-item-btn').addEventListener('click', addItem);
    document.getElementById('remove-item-btn').addEventListener('click', removeItem);
    document.getElementById('sort-attack-damage-btn').addEventListener('click', () => searchItemsStats('Attack Damage'));
    document.getElementById('sort-ability-power-btn').addEventListener('click', () => searchItemsStats('Ability Power'));
    document.getElementById('sort-armor-btn').addEventListener('click', () => searchItemsStats('Armor'));
    document.getElementById('sort-magic-resist-btn').addEventListener('click', () => searchItemsStats('Magic Resist'));
    document.getElementById('sort-health-btn').addEventListener('click', () => searchItemsStats('Health'));
    document.getElementById('sort-mana-btn').addEventListener('click', () => searchItemsStats('Mana'));
    document.getElementById('sort-none-btn').addEventListener('click', () => searchItemsStats(''));
    document.getElementById('items-search-field').addEventListener('input', (event) => searchItemsText(event.target.value));
    document.getElementById('randomize-build-btn').addEventListener('click', randomizeBuild);
    document.getElementById('save-build-btn').addEventListener('click', saveBuild);
    document.getElementById('logout-link').addEventListener('click', () => sessionStorage.clear());
}); 

/*-----Item Functions-----*/
function populateItemsTable(items) { // Accepts a JSON of items
    const itemsTableBody = document.getElementById('items-table-body');
    itemsTableBody.innerHTML = ''; // Clear existing items
    let row = itemsTableBody.insertRow();
    items.forEach((item, index) => {
        if (index % 6 === 0 && index !== 0) {
            row = itemsTableBody.insertRow();
        }
        const cell = row.insertCell();
        cell.style.width = "16.66%";
        // Create the item images
        const img = document.createElement('img');
        img.src = `${ddragonBaseUrl}${item.id}.png`;
        img.alt = item.name;
        img.style.width = "50px";
        img.style.cursor = "pointer";
        img.addEventListener('click', () => selectItem(item.id.toString()));
        cell.appendChild(img);
        // Create item text
        const text = document.createElement('div');
        text.textContent = item.name;
        text.style.textAlign = "center";
        cell.appendChild(text);
    });
}

function searchItemsText(itemName) {
    fetch('/items')
        .then(response => response.json())
        .then(items => {
            const filteredItems = items.filter(item => item.name.toLowerCase().includes(itemName.toLowerCase()));
            populateItemsTable(filteredItems);
        })
        .catch(error => console.error('Error fetching filtered items', error));
}

function searchItemsStats(statName) {
    fetch('/items')
        .then(response => response.json())
        .then(items => {
            if(statName == '') {
                populateItemsTable(items);
                return;
            }
            const filteredItems = items.filter(item => item.stats[statName] > 0);
            populateItemsTable(filteredItems);
        })
        .catch(error => console.error('Error fetching filtered items', error));
}

function selectItem(itemId) {
    sessionStorage.setItem('selectedItem', itemId.toString());
    fetch(`/items/${itemId}`)
        .then(response => response.json())
        .then(item => {
            let selectItemList = document.getElementById('select-item-list');
            selectItemList.innerHTML = '';
            const itemImage = document.createElement('img');
            itemImage.src = `${ddragonBaseUrl}${itemId}.png`;
            itemImage.alt = item.name;
            itemImage.style.width = "100px";
            selectItemList.appendChild(itemImage);

            // Add item name
            const itemName = document.createElement('h3');
            itemName.textContent = item.name;
            selectItemList.appendChild(itemName);

            // Add item stats
            Object.entries(item.stats).forEach(([stat, value]) => {
                const statEntry = document.createElement('p');
                statEntry.textContent = `${stat}: ${value}`;
                selectItemList.appendChild(statEntry);
            });

            // For testing
            console.log("Item ID: "+item.id);
        })
        .catch(error => console.error('Error fetching item', error));
}

function addItem() {
    let build = JSON.parse(sessionStorage.getItem('build')) || [];
    let itemId = sessionStorage.getItem('selectedItem');
    if (!build.includes(itemId) && build.length < 6) {
        build.push(itemId);
        sessionStorage.setItem('build', JSON.stringify(build));
        updateBuild();
    } else {
        console.log('Cannot add item');
    }
}

function removeItem() {
    let build = JSON.parse(sessionStorage.getItem('build')) || [];
    console.log(build);
    let itemId = sessionStorage.getItem('selectedItem');
    const index = build.indexOf(itemId);
    if (index > -1) {
        build.splice(index, 1);
        sessionStorage.setItem('build', JSON.stringify(build));
        updateBuild();
    } else {
        console.log('Item not found in build');
    }
}

function updateBuild() { // Assumes two elements: build-list and calculation-list
    const buildList = document.getElementById('build-list');
    buildList.innerHTML = '';
    let build = JSON.parse(sessionStorage.getItem('build')) || [];
    let totalStats = {};
    Promise.all(build.map(itemId => fetch(`/items/${itemId}`).then(response => response.json())))
        .then(items => {
            items.forEach(item => {
                // Update items in build
                const li = document.createElement('li');
                li.style.display = "flex";
                li.style.flexDirection = "column";
                li.style.alignItems = "center";
                li.style.marginBottom = "10px";

                // Create an image element for the item
                const img = document.createElement('img');
                img.src = `${ddragonBaseUrl}${item.id}.png`;
                img.alt = item.name;
                img.style.width = "50px";
                img.style.cursor = "pointer"; 
                img.addEventListener('click', () => selectItem(item.id.toString()));
                li.appendChild(img);

                // Create a text element for the item name
                const text = document.createElement('div');
                text.textContent = item.name;
                text.style.textAlign = "center";
                li.appendChild(text);

                buildList.appendChild(li); 

                // Aggregate stats for each item
                Object.keys(item.stats).forEach(stat => {
                    if (!totalStats[stat]) {
                        totalStats[stat] = 0;
                    }
                    totalStats[stat] += item.stats[stat];
                });
            });

            // Update calculations from build
            const calculationList = document.getElementById('calculation-list');
            calculationList.innerHTML = '';
            Object.entries(totalStats).forEach(([stat, value]) => {
                const statEntry = document.createElement('p');
                statEntry.textContent = `${stat}: ${value}`;
                calculationList.appendChild(statEntry);
            });
        })
        .catch(error => console.error('Error fetching items:', error));
}

function filterItems(searchValue) {
    fetch('/items')
        .then(response => response.json())
        .then(items => {
            const filteredItems = items.filter(item => item.name.toLowerCase().includes(searchValue));
            populateItemsTable(filteredItems);
        })
        .catch(error => console.error('Error fetching filtered items', error));
}

function randomizeBuild() {
    fetch('/items')
        .then(response => response.json())
        .then(items => {
            let build = [];
            while (build.length < 6) {
                const randomIndex = Math.floor(Math.random() * items.length);
                const item = items[randomIndex];
                const itemId = String(item.id);
                if (!build.some(b => b.id === itemId)) {
                    build.push(itemId);
                }
            }
            sessionStorage.setItem('build', JSON.stringify(build));
            updateBuild();
        })
        .catch(error => console.error('Error fetching items:', error));
}

function saveBuild() {
    let buildItems = JSON.parse(sessionStorage.getItem('build')) || [];
    let items = buildItems.map(item => ({ item_id: item }));
    let buildName = document.getElementById('build-name-field').value;
    let buildData = {
        build: {
            name: buildName
        },
        build_items: items
    };

    fetch('/builds', {
        method: 'POST', 
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify(buildData) 
    })
    .then(response => response.json())
    .then(data => {
        alert('Build saved');
    })
    .catch((error) => {
        console.error('Build failed to save:', error);
    });
}

document.addEventListener('DOMContentLoaded', function() {
    const sortButtons = document.querySelectorAll('.button');
    sortButtons.forEach(button => {
        button.addEventListener('click', function() {
            sortButtons.forEach(btn => btn.classList.remove('selected-button'));
            this.classList.add('selected-button');
        });
    });
});
