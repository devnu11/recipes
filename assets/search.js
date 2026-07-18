// Client-side search over the Jekyll-generated search.json index.
// Substring match, case-insensitive, against title + category + body text.
(function () {
    "use strict";

    var box = document.getElementById("search-box");
    var resultsEl = document.getElementById("search-results");
    var indexEl = document.getElementById("recipe-index");
    var recipes = null;

    function loadIndex() {
        if (recipes) return Promise.resolve(recipes);
        var base = document.querySelector("script[src$='search.js']")
            .getAttribute("src").replace("assets/search.js", "");
        return fetch(base + "search.json")
            .then(function (r) { return r.json(); })
            .then(function (data) { recipes = data; return recipes; });
    }

    function matches(recipe, query) {
        return (recipe.title || "").toLowerCase().indexOf(query) !== -1
            || (recipe.category || "").toLowerCase().indexOf(query) !== -1
            || (recipe.text || "").toLowerCase().indexOf(query) !== -1;
    }

    function render(hits) {
        resultsEl.innerHTML = "";
        if (hits.length === 0) {
            var li = document.createElement("li");
            li.className = "no-results";
            li.textContent = "No recipes found.";
            resultsEl.appendChild(li);
            return;
        }
        hits.forEach(function (r) {
            var li = document.createElement("li");
            var a = document.createElement("a");
            a.href = r.url;
            a.textContent = r.title;
            li.appendChild(a);
            if (r.category) {
                var span = document.createElement("span");
                span.className = "result-category";
                span.textContent = " — " + r.category;
                li.appendChild(span);
            }
            resultsEl.appendChild(li);
        });
    }

    function onInput() {
        var query = box.value.trim().toLowerCase();
        if (query.length < 2) {
            resultsEl.hidden = true;
            indexEl.hidden = false;
            return;
        }
        loadIndex().then(function (all) {
            render(all.filter(function (r) { return matches(r, query); }));
            resultsEl.hidden = false;
            indexEl.hidden = true;
        });
    }

    box.addEventListener("input", onInput);
})();
