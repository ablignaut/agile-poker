function loadDefinitions() {
  const el = document.querySelector('#sizing-definitions-data');
  if (!el) return {};
  try {
    return JSON.parse(el.textContent);
  } catch (e) {
    return {};
  }
}

function panelFor(category) {
  return document.querySelector(`[data-sizing-panel="${category}"]`);
}

function levelLabel(level) {
  return level.replace(/_/g, ' ').replace(/^./, (c) => c.toUpperCase());
}

function renderPanel(category, level) {
  const panel = panelFor(category);
  if (!panel) return;

  const definitions = loadDefinitions();
  const description = level && definitions[category]?.[level];

  if (!description) {
    panel.innerHTML = '<em class="text-muted">Pick a value to see what it means.</em>';
    return;
  }

  const strong = document.createElement('strong');
  strong.textContent = levelLabel(level);
  panel.replaceChildren(strong, document.createTextNode(` — ${description}`));
}

function handleChange(event) {
  const select = event.target;
  if (!select.matches?.('select[data-sizing-select]')) return;

  const option = select.options[select.selectedIndex];
  renderPanel(select.dataset.sizingSelect, option?.dataset.sizingLevel);
}

document.addEventListener('change', handleChange);

document.addEventListener('turbo:load', () => {
  document.querySelectorAll('select[data-sizing-select]').forEach((select) => {
    const option = select.options[select.selectedIndex];
    renderPanel(select.dataset.sizingSelect, option?.dataset.sizingLevel);
  });
});
