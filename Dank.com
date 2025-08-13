<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1" />
<title>Dank Accounting — SME Starter</title>
<meta name="description" content="Dank Accounting: double-entry journals, BS/IS/CF, ratios, AI review. 100% static, GitHub Pages-ready.">
<link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
<link rel="preconnect" href="https://unpkg.com" crossorigin>
<style>
  :root{
    --bg:#0f172a; --panel:#0b1220; --muted:#94a3b8; --text:#e2e8f0;
    --brand:#6ee7b7; --accent:#22d3ee; --danger:#ef4444; --ok:#10b981;
    --card:#0a0f1c; --border:#1f2937; --chip:#1e293b;
  }
  *{box-sizing:border-box}
  html,body{height:100%}
  body{
    margin:0; font:14px/1.5 ui-sans-serif,system-ui,Segoe UI,Roboto,Inter,Arial;
    color:var(--text); background:radial-gradient(1200px 600px at 80% -10%,#0a1a2f,transparent),var(--bg);
    display:flex; min-height:100vh; overflow:hidden;
  }
  a{color:inherit;text-decoration:none}
  .sidebar{
    width:260px; min-width:260px; background:linear-gradient(180deg,#0b1220,#050a14);
    border-right:1px solid var(--border); padding:16px; display:flex; flex-direction:column; gap:10px;
  }
  .brand{display:flex; align-items:center; gap:10px; font-weight:800; letter-spacing:.3px}
  .brand .logo{width:34px;height:34px;border-radius:9px;background:
    conic-gradient(from 180deg at 50% 50%,var(--brand),var(--accent),#60a5fa,var(--brand));
    box-shadow:0 0 20px #22d3ee55 inset, 0 8px 28px #22d3ee22;
  }
  .nav{margin-top:10px; display:grid; gap:6px}
  .nav button{
    text-align:left; background:transparent; color:var(--text);
    border:1px solid transparent; padding:10px 12px; border-radius:10px; cursor:pointer;
  }
  .nav button.active, .nav button:hover{background:var(--chip); border-color:#273449}
  .grow{flex:1}
  .footer{font-size:12px;color:var(--muted)}
  .content{flex:1; overflow:auto; padding:18px 22px}
  .toolbar{display:flex; gap:10px; align-items:center; flex-wrap:wrap; margin-bottom:14px}
  .pill{background:var(--chip); border:1px solid #2a364a; padding:6px 10px; border-radius:999px; color:var(--muted)}
  .grid{display:grid; gap:14px}
  .cols-2{grid-template-columns:repeat(2,minmax(0,1fr))}
  .cols-3{grid-template-columns:repeat(3,minmax(0,1fr))}
  @media(max-width:1100px){.cols-3{grid-template-columns:repeat(2,minmax(0,1fr))}}
  @media(max-width:880px){.sidebar{position:fixed;z-index:50;transform:translateX(-100%);transition:.25s}
    .sidebar.show{transform:translateX(0)} .content{padding-top:64px}}
  .topbar{
    position:sticky; top:0; z-index:5; background:linear-gradient(180deg,#0a0f1c,#0a0f1ccc);
    backdrop-filter: blur(6px); display:flex; align-items:center; justify-content:space-between;
    padding:10px 0 14px; margin-bottom:12px; border-bottom:1px solid var(--border);
  }
  .card{
    background:linear-gradient(180deg,#0a0f1c,#060b15);
    border:1px solid var(--border); border-radius:14px; padding:14px;
    box-shadow:0 10px 40px #00000040 inset, 0 6px 30px #00000020;
  }
  .card h3{margin:0 0 8px 0; font-size:16px}
  .muted{color:var(--muted)}
  .tag{display:inline-block; font-size:12px; padding:3px 8px; border-radius:999px; border:1px solid #2a364a; background:var(--chip); color:var(--text)}
  .btn{
    border:1px solid #2a364a; background:#0f1626; color:var(--text);
    padding:8px 12px; border-radius:10px; cursor:pointer;
  }
  .btn:hover{border-color:#3a4b64}
  .btn.primary{background:linear-gradient(180deg,#0c2e2a,#10333b); border-color:#165a68}
  .btn.danger{border-color:#6b1d1d;background:#2a0f12}
  input,select,textarea{
    width:100%; background:#0b1220; color:var(--text);
    border:1px solid #223048; border-radius:10px; padding:8px 10px;
  }
  table{width:100%; border-collapse:collapse; font-size:13px}
  th,td{padding:10px; border-bottom:1px solid #1d2739}
  th{text-align:left; color:#cbd5e1; background:#0c1220}
  .right{text-align:right}
  .flex{display:flex; gap:10px}
  .chip{padding:5px 8px; border:1px solid #324058; border-radius:8px; background:#0b1220; color:var(--muted); font-size:12px}
  .ok{color:var(--ok)} .bad{color:var(--danger)}
  .code{font-family:ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; font-size:12px}
  .kbd{border:1px solid #2a364a;background:#0b1220;padding:2px 6px;border-radius:6px}
  .note{font-size:12px;color:var(--muted)}
  .hl{color:var(--brand)}
</style>
</head>
<body>
  <!-- Sidebar -->
  <aside class="sidebar" id="sidebar">
    <div class="brand">
      <div class="logo"></div>
      <div>DANK <span class="muted">ACCOUNTING</span></div>
    </div>
    <div class="nav" id="nav">
      <button data-view="dashboard" class="active">🏠 Dashboard</button>
      <button data-view="journals">🧾 Journals</button>
      <button data-view="reports">📊 Reports (BS/IS/CF)</button>
      <button data-view="ai">🤖 AI Review</button>
      <button data-view="import">⬆️ Import / Export</button>
      <button data-view="settings">⚙️ Settings</button>
    </div>
    <div class="grow"></div>
    <div class="footer">
      © <span id="year"></span> <b>Dank</b>. All local, no server.
    </div>
  </aside>

  <!-- Main content -->
  <main class="content">
    <div class="topbar">
      <div class="flex" style="gap:8px;align-items:center">
        <button class="btn" id="menuBtn">☰</button>
        <span class="pill">Build: <span class="muted">static / GitHub Pages ready</span></span>
      </div>
      <div class="flex">
        <span class="chip">Org: <b>Dank</b></span>
        <span class="chip">Books: <span id="bookName">Default</span></span>
        <button class="btn danger" id="reset">Reset Data</button>
      </div>
    </div>

    <!-- DASHBOARD -->
    <section id="view-dashboard" class="grid cols-3">
      <div class="card">
        <h3>Snapshot</h3>
        <div class="muted">Key balances & ratios (YTD)</div>
        <div id="dashSnapshot" style="margin-top:10px"></div>
      </div>
      <div class="card">
        <h3>Cash Position</h3>
        <table>
          <thead><tr><th>Account</th><th class="right">Balance</th></tr></thead>
          <tbody id="cashTable"></tbody>
        </table>
      </div>
      <div class="card">
        <h3>Quick Actions</h3>
        <div class="grid">
          <button class="btn primary" onclick="ui.newEntry()">+ New Journal Entry</button>
          <button class="btn" onclick="ui.goto('reports')">View Reports</button>
          <button class="btn" onclick="ui.goto('ai')">Run AI Review</button>
        </div>
        <div class="note" style="margin-top:10px">
          Tip: Press <span class="kbd">/</span> to open the command palette.
        </div>
      </div>

      <div class="card">
        <h3>Recent Entries</h3>
        <table>
          <thead><tr><th>Date</th><th>Memo</th><th class="right">Lines</th><th class="right">Amount</th></tr></thead>
          <tbody id="recentEntries"></tbody>
        </table>
      </div>
      <div class="card">
        <h3>Trial Balance</h3>
        <table>
          <thead><tr><th>Account</th><th class="right">Debit</th><th class="right">Credit</th></tr></thead>
          <tbody id="trialBody"></tbody>
          <tfoot><tr><th>Total</th><th class="right" id="tbD"></th><th class="right" id="tbC"></th></tr></tfoot>
        </table>
      </div>
      <div class="card">
        <h3>Health Checks</h3>
        <div id="health"></div>
      </div>
    </section>

    <!-- JOURNALS -->
    <section id="view-journals" class="grid">
      <div class="card">
        <h3>New Journal Entry</h3>
        <div class="grid cols-2">
          <div>
            <label>Date</label>
            <input id="jeDate" type="date"/>
          </div>
          <div>
            <label>Memo</label>
            <input id="jeMemo" placeholder="e.g., Sale, rent, equity injection"/>
          </div>
        </div>
        <div id="jeLines" class="grid" style="margin-top:10px"></div>
        <div class="flex" style="justify-content:space-between;margin-top:10px">
          <div class="muted">Balanced: <span id="jeBalance" class="hl">0.00</span></div>
          <div class="flex">
            <button class="btn" onclick="ui.addLine()">+ Add Line</button>
            <button class="btn primary" onclick="ui.saveJE()">Post Entry</button>
          </div>
        </div>
      </div>

      <div class="card">
        <h3>Journal Entries</h3>
        <table>
          <thead><tr><th>#</th><th>Date</th><th>Memo</th><th class="right">Lines</th><th class="right">Amount</th><th></th></tr></thead>
          <tbody id="jeTable"></tbody>
        </table>
      </div>
    </section>

    <!-- REPORTS -->
    <section id="view-reports" class="grid">
      <div class="card">
        <h3>Reporting Period</h3>
        <div class="grid cols-3">
          <div><label>Start</label><input type="date" id="rStart"></div>
          <div><label>End</label><input type="date" id="rEnd"></div>
          <div style="align-self:end"><button class="btn primary" onclick="ui.refreshReports()">Refresh</button></div>
        </div>
        <div class="note" style="margin-top:6px">Cash Flow uses **indirect** method between Start and End.</div>
      </div>

      <div class="grid cols-3">
        <div class="card">
          <h3>Balance Sheet</h3>
          <div id="bs"></div>
        </div>
        <div class="card">
          <h3>Income Statement</h3>
          <div id="is"></div>
        </div>
        <div class="card">
          <h3>Cash Flow (Indirect)</h3>
          <div id="cf"></div>
        </div>
      </div>
    </section>

    <!-- AI -->
    <section id="view-ai" class="grid cols-2">
      <div class="card">
        <h3>Offline Review (Rule‑based)</h3>
        <div id="aiOffline"></div>
        <button class="btn" style="margin-top:8px" onclick="ui.runOfflineAI()">Run Checks</button>
      </div>
      <div class="card">
        <h3>Cloud AI Review (Optional BYO API key)</h3>
        <div class="note">Enter an API key and model in <b>Settings</b>. We’ll send a compact, redacted summary of your statements.</div>
        <textarea id="aiAsk" rows="6" placeholder="Ask: What stands out in liquidity and profitability? Any red flags?"></textarea>
        <button class="btn primary" style="margin-top:8px" onclick="ui.runCloudAI()">Ask AI</button>
        <pre id="aiOut" class="card code" style="white-space:pre-wrap;margin-top:10px;max-height:300px;overflow:auto"></pre>
      </div>
    </section>

    <!-- IMPORT / EXPORT -->
    <section id="view-import" class="grid cols-2">
      <div class="card">
        <h3>Import Journals (CSV/JSON)</h3>
        <div class="note">CSV format: date, memo, account, debit, credit (multiple lines with same date+memo form a single entry).</div>
        <input type="file" id="fileInput" accept=".csv,.json" />
        <button class="btn" style="margin-top:8px" onclick="ui.importFile()">Import File</button>
      </div>
      <div class="card">
        <h3>Export</h3>
        <div class="grid">
          <button class="btn" onclick="data.exportJSON()">Export JSON</button>
          <button class="btn" onclick="data.exportCSV()">Export CSV (lines)</button>
        </div>
      </div>
      <div class="card">
        <h3>Sample Data</h3>
        <div class="grid">
          <button class="btn" onclick="data.loadSample()">Load Sample Company</button>
        </div>
      </div>
    </section>

    <!-- SETTINGS -->
    <section id="view-settings" class="grid cols-2">
      <div class="card">
        <h3>Organization</h3>
        <label>Book Name</label>
        <input id="sBook" placeholder="e.g., Dank — FY2025"/>
        <div class="note" style="margin-top:6px">Stored locally only.</div>
        <button class="btn primary" style="margin-top:10px" onclick="ui.saveSettings()">Save</button>
      </div>
      <div class="card">
        <h3>Cloud AI (BYO Key)</h3>
        <div class="grid">
          <div>
            <label>API Endpoint</label>
            <input id="sAIEndpoint" placeholder="https://api.openai.com/v1/chat/completions" />
          </div>
          <div>
            <label>Model</label>
            <input id="sAIModel" placeholder="gpt-4o-mini" />
          </div>
          <div>
            <label>API Key</label>
            <input id="sAIKey" type="password" placeholder="sk-..." />
          </div>
        </div>
        <div class="note" style="margin-top:6px">
          Keys are saved to <b>your browser’s localStorage</b> only and used client‑side.
        </div>
        <button class="btn primary" style="margin-top:10px" onclick="ui.saveAI()">Save AI Settings</button>
      </div>
      <div class="card">
        <h3>Chart of Accounts</h3>
        <div id="coa"></div>
        <div class="flex" style="margin-top:8px">
          <input id="coaName" placeholder="Account name">
          <select id="coaType">
            <option>Asset</option><option>Liability</option><option>Equity</option>
            <option>Revenue</option><option>Expense</option><option>COGS</option>
          </select>
          <button class="btn" onclick="ui.addAccount()">Add</button>
        </div>
      </div>
    </section>
  </main>

  <!-- External libs (CDN) -->
  <script src="https://cdn.jsdelivr.net/npm/papaparse@5.4.1/papaparse.min.js" defer></script>

  <script>
  /**************
   * DANK ACCOUNTING — client-only ledger
   * - double-entry engine
   * - BS/IS/CF (indirect)
   * - ratios + health checks
   * - CSV/JSON import/export
   * - Offline AI rules + optional cloud AI (BYO key)
   **************/

  const storeKey = 'dank_books_v1';

  const state = {
    org: { bookName: 'Dank — Starter' },
    ai: { endpoint:'', model:'', key:'' },
    accounts: [],                // [{id,name,type}]
    entries: [],                 // [{id,date,memo,lines:[{accountId,debit,credit}]}]
    seq: { acc:1, je:1 }
  };

  const TYPES = ['Asset','Liability','Equity','Revenue','Expense','COGS'];

  const ui = {
    goto(view){ document.querySelectorAll('.nav button').forEach(b=>b.classList.toggle('active',b.dataset.view===view));
                document.querySelectorAll('main section').forEach(s=>s.style.display='none');
                document.getElementById('view-'+view).style.display='grid';
                if(view==='dashboard') render.dashboard();
                if(view==='journals') render.journals();
                if(view==='reports') render.reports();
                if(view==='ai') ui.runOfflineAI();
                if(view==='settings') render.settings(); },
    newEntry(){ this.goto('journals'); initNewJE(); },
    addLine(){ addJELine(); },
    saveJE(){ saveJE(); },
    refreshReports(){ render.reports(); },
    importFile(){ importFile(); },
    saveSettings(){ state.org.bookName = document.getElementById('sBook').value || 'Dank — Starter';
                    save(); render.top(); alert('Saved'); },
    saveAI(){ state.ai.endpoint = val('sAIEndpoint'); state.ai.model = val('sAIModel'); state.ai.key = val('sAIKey'); save(); alert('AI settings saved'); },
    addAccount(){ const name = val('coaName').trim(); const type = val('coaType'); if(!name) return;
                  data.addAccount(name,type); render.settings(); render.dashboard(); },
    runOfflineAI(){ render.offlineAI(); },
    async runCloudAI(){ await cloudAI(); }
  };

  const render = {
    top(){
      byId('year').textContent = new Date().getFullYear();
      byId('bookName').textContent = state.org.bookName;
    },
    dashboard(){
      // cash table
      const cashIds = idsByType('Asset').filter(id => accById(id).name.toLowerCase().includes('cash') || accById(id).name.toLowerCase().includes('bank'));
      const cashRows = cashIds.map(id=>{
        const bal = balanceOf(id);
        return `<tr><td>${accById(id).name}</td><td class="right">${fmt(bal)}</td></tr>`;
      }).join('') || `<tr><td class="muted">No cash/bank accounts</td><td></td></tr>`;
      byId('cashTable').innerHTML = cashRows;

      // snapshot & ratios
      const snap = calc.snap();
      byId('dashSnapshot').innerHTML = `
        <div class="grid">
          <div class="chip">Assets: <b>${fmt(snap.assets)}</b></div>
          <div class="chip">Liab: <b>${fmt(snap.liabs)}</b></div>
          <div class="chip">Equity: <b>${fmt(snap.equity)}</b></div>
          <div class="chip">Revenue: <b>${fmt(snap.revenue)}</b></div>
          <div class="chip">Expenses: <b>${fmt(snap.expenses)}</b></div>
          <div class="chip">Net Income: <b>${fmt(snap.net)}</b></div>
          <div class="chip">Current Ratio: <b>${num(calc.currentRatio()).toFixed(2)}</b></div>
          <div class="chip">Debt/Equity: <b>${num(calc.debtToEquity()).toFixed(2)}</b></div>
        </div>`;

      // recent entries
      const rec = [...state.entries].sort((a,b)=>b.date.localeCompare(a.date)).slice(0,8);
      byId('recentEntries').innerHTML = rec.map((e,i)=>{
        const amt = sum(e.lines.map(l=>l.debit));
        return `<tr><td>${e.date}</td><td>${escapeHTML(e.memo||'')}</td><td class="right">${e.lines.length}</td><td class="right">${fmt(amt)}</td></tr>`;
      }).join('') || `<tr><td colspan="4" class="muted">No entries yet</td></tr>`;

      // trial balance
      const tb = calc.trialBalance();
      byId('trialBody').innerHTML = tb.rows.map(r=>`<tr><td>${escapeHTML(r.name)}</td><td class="right">${fmt(r.debit)}</td><td class="right">${fmt(r.credit)}</td></tr>`).join('');
      byId('tbD').textContent = fmt(tb.totalD); byId('tbC').textContent = fmt(tb.totalC);

      // health
      const checks = healthChecks();
      byId('health').innerHTML = checks.map(c=>`<div class="flex" style="justify-content:space-between"><span>${c.msg}</span><span class="${c.ok?'ok':'bad'}">${c.ok?'✔️':'❗'}</span></div>`).join('');
    },
    journals(){
      // table
      const rows = state.entries.map((e,idx)=>{
        const amt = sum(e.lines.map(l=>l.debit));
        return `<tr>
          <td>${idx+1}</td><td>${e.date}</td><td>${escapeHTML(e.memo||'')}</td>
          <td class="right">${e.lines.length}</td><td class="right">${fmt(amt)}</td>
          <td class="right"><button class="btn" onclick="uiEdit(${e.id})">✏️</button>
                            <button class="btn danger" onclick="uiDelete(${e.id})">🗑️</button></td>
        </tr>`;
      }).join('') || `<tr><td colspan="6" class="muted">No entries yet</td></tr>`;
      byId('jeTable').innerHTML = rows;

      // new JE form
      initNewJE();
    },
    reports(){
      const start = val('rStart') || '1900-01-01';
      const end = val('rEnd') || today();
      const bs = calc.balanceSheet(end);
      const is = calc.incomeStatement(start,end);
      const cf = calc.cashFlowIndirect(start,end);

      byId('bs').innerHTML = table2([
        ['Assets', ''], ...rowsFromMap(bs.assets),
        ['Total Assets', fmt(bs.totalAssets)],
        ['—',''],
        ['Liabilities',''], ...rowsFromMap(bs.liabs),
        ['Total Liabilities', fmt(bs.totalLiabs)],
        ['Equity',''], ...rowsFromMap(bs.equity),
        ['Total Equity', fmt(bs.totalEquity)],
        ['—',''],
        ['Check (A = L + E)', bs.ok ? '<span class="ok">OK</span>' : '<span class="bad">Mismatch</span>']
      ]);

      byId('is').innerHTML = table2([
        ['Revenue', fmt(is.revenue)],
        ['COGS', fmt(-is.cogs)],
        ['Gross Profit', fmt(is.gross)],
        ['Operating Expenses', fmt(-is.expenses)],
        ['Operating Income', fmt(is.operating)],
        ['Other', fmt(is.other)],
        ['Net Income', fmt(is.net)]
      ]);

      byId('cf').innerHTML = table2([
        ['Net Income', fmt(cf.netIncome)],
        ['+ Depreciation/Non‑cash', fmt(cf.nonCash)],
        ['± Working Capital', fmt(cf.workingCapital)],
        ['Cash from Operations', fmt(cf.cfo)],
        ['Capex (Δ PPE)', fmt(cf.capex)],
        ['Cash from Investing', fmt(cf.cfi)],
        ['Debt/Equity Financing (net)', fmt(cf.cff)],
        ['Net Cash Change', fmt(cf.netChange)],
      ]);
    },
    offlineAI(){
      const res = aiRuleBased();
      byId('aiOffline').innerHTML = res.map(r => `<div class="flex" style="justify-content:space-between">
        <span>${r.topic}: <span class="muted">${r.detail}</span></span>
        <span class="${r.severity==='ok'?'ok':'bad'}">${r.severity==='ok'?'OK':'Check'}</span>
      </div>`).join('') || '<div class="muted">No diagnostics.</div>';
    },
    settings(){
      byId('sBook').value = state.org.bookName || '';
      byId('sAIEndpoint').value = state.ai.endpoint || '';
      byId('sAIModel').value = state.ai.model || '';
      byId('sAIKey').value = state.ai.key || '';
      // chart of accounts
      const rows = state.accounts.map(a=>`<div class="flex" style="justify-content:space-between">
        <span>${escapeHTML(a.name)} <span class="muted">(${a.type})</span></span>
        <span class="muted">#${a.id}</span>
      </div>`).join('') || '<div class="muted">No accounts yet.</div>';
      byId('coa').innerHTML = rows;
    }
  };

  const data = {
    init(){
      const raw = localStorage.getItem(storeKey);
      if(raw){ try{ const saved = JSON.parse(raw); Object.assign(state, saved); }catch(e){} }
      if(!state.accounts.length) this.seedCOA();
      render.top(); ui.goto('dashboard');
    },
    seedCOA(){
      [
        ['Cash', 'Asset'], ['Bank', 'Asset'], ['Accounts Receivable','Asset'], ['Inventory','Asset'],
        ['Prepaid Expenses','Asset'], ['PPE','Asset'],
        ['Accounts Payable','Liability'], ['Accrued Expenses','Liability'], ['Short-term Debt','Liability'], ['Long-term Debt','Liability'],
        ['Owner’s Equity','Equity'], ['Retained Earnings','Equity'],
        ['Sales Revenue','Revenue'], ['Other Income','Revenue'],
        ['COGS','COGS'],
        ['Rent Expense','Expense'], ['Utilities Expense','Expense'], ['Salaries Expense','Expense'], ['Depreciation Expense','Expense']
      ].forEach(([n,t])=>this.addAccount(n,t));
      save();
    },
    addAccount(name,type){
      state.accounts.push({ id: state.seq.acc++, name, type });
      save();
    },
    loadSample(){
      // wipe current
      state.entries = []; state.seq.je = 1;
      const A = name => state.accounts.find(a=>a.name===name).id;
      // Sample month
      postJE('2025-07-01','Owner capital',[
        L(A('Cash'),10000,0), L(A('Owner’s Equity'),0,10000)
      ]);
      postJE('2025-07-02','Inventory purchase cash',[
        L(A('Inventory'),3000,0), L(A('Cash'),0,3000)
      ]);
      postJE('2025-07-05','Credit sale',[
        L(A('Accounts Receivable'),5000,0), L(A('Sales Revenue'),0,5000), L(A('COGS'),2000,0), L(A('Inventory'),0,2000)
      ]);
      postJE('2025-07-10','Collect receivable',[
        L(A('Cash'),4000,0), L(A('Accounts Receivable'),0,4000)
      ]);
      postJE('2025-07-15','Pay salaries',[
        L(A('Salaries Expense'),1500,0), L(A('Cash'),0,1500)
      ]);
      postJE('2025-07-20','Rent',[
        L(A('Rent Expense'),700,0), L(A('Cash'),0,700)
      ]);
      postJE('2025-07-25','Utilities',[
        L(A('Utilities Expense'),300,0), L(A('Cash'),0,300)
      ]);
      postJE('2025-07-28','Borrow ST debt',[
        L(A('Cash'),2000,0), L(A('Short-term Debt'),0,2000)
      ]);
      postJE('2025-07-30','Depreciation',[
        L(A('Depreciation Expense'),250,0), L(A('PPE'),0,250)
      ]);
      save(); ui.goto('dashboard');
    },
    exportJSON(){
      download('dank-books.json', JSON.stringify(state,null,2));
    },
    exportCSV(){
      // flatten lines
      const rows = [];
      state.entries.forEach(e => e.lines.forEach(l=>{
        rows.push({
          id:e.id, date:e.date, memo:e.memo,
          account: accById(l.accountId).name, debit: l.debit, credit: l.credit
        });
      }));
      const csv = Papa.unparse(rows);
      download('dank-journal-lines.csv', csv);
    }
  };

  /* ---------- Calculation Engine ---------- */

  function idsByType(type){ return state.accounts.filter(a=>a.type===type).map(a=>a.id); }
  function accById(id){ return state.accounts.find(a=>a.id===id); }

  function balanceOf(accountId, upToDate){
    // sum debits - credits for Asset/Expense/COGS; reverse for Liability/Equity/Revenue
    const acc = accById(accountId); if(!acc) return 0;
    const isNormalDebit = ['Asset','Expense','COGS'].includes(acc.type);
    const lines = state.entries.flatMap(e => (!upToDate || e.date<=upToDate) ? e.lines : []);
    const deb = sum(lines.filter(l=>l.accountId===accountId).map(l=>l.debit));
    const cre = sum(lines.filter(l=>l.accountId===accountId).map(l=>l.credit));
    return isNormalDebit ? (deb - cre) : (cre - deb); // positive = normal side
  }

  const calc = {
    trialBalance(){
      const rows = state.accounts.map(a=>{
        const isNormalDebit = ['Asset','Expense','COGS'].includes(a.type);
        const bal = balanceOf(a.id);
        return { name:a.name, debit: isNormalDebit ? Math.max(bal,0) : 0, credit: !isNormalDebit ? Math.max(bal,0) : 0 };
      });
      const totalD = sum(rows.map(r=>r.debit)), totalC = sum(rows.map(r=>r.credit));
      return { rows, totalD, totalC };
    },
    snap(){
      const byT = t => sum(idsByType(t).map(id=>balanceOf(id)));
      const assets = byT('Asset'), liabs = byT('Liability'), equity = byT('Equity');
      const revenue = byT('Revenue'), cogs = byT('COGS'), expenses = byT('Expense');
      const net = revenue - (expenses + cogs);
      return {assets, liabs, equity, revenue, cogs, expenses, net};
    },
    currentRatio(){
      // Approx: Current Assets (Cash, AR, Inventory, Prepaids) / Current Liabilities (AP, Accrued, Short-term Debt)
      const caNames = ['Cash','Bank','Accounts Receivable','Inventory','Prepaid Expenses'];
      const clNames = ['Accounts Payable','Accrued Expenses','Short-term Debt'];
      const CA = sum(state.accounts.filter(a=>caNames.includes(a.name)).map(a=>balanceOf(a.id)));
      const CL = sum(state.accounts.filter(a=>clNames.includes(a.name)).map(a=>balanceOf(a.id)));
      return CL ? CA/CL : Infinity;
    },
    debtToEquity(){
      const debt = sum(state.accounts.filter(a=>a.type==='Liability').map(a=>balanceOf(a.id)));
      const eq = sum(state.accounts.filter(a=>a.type==='Equity').map(a=>balanceOf(a.id)));
      return eq ? debt/eq : Infinity;
    },
    incomeStatement(start,end){
      const byT = t => sum(idsByType(t).map(id=>balanceDelta(id,start,end)));
      const revenue = byT('Revenue');
      const cogs = byT('COGS');
      const expenses = byT('Expense');
      const gross = revenue - cogs;
      const operating = gross - expenses;
      const other = 0; // can expand
      const net = operating + other;
      return {revenue,cogs,expenses,gross,operating,other,net};
    },
    balanceSheet(asOf){
      const assets = mapType('Asset', asOf);
      const liabs  = mapType('Liability', asOf);
      const equity = mapType('Equity', asOf);
      const totalAssets = sum(Object.values(assets));
      const totalLiabs  = sum(Object.values(liabs));
      const totalEquity = sum(Object.values(equity));
      return {assets,liabs,equity,totalAssets,totalLiabs,totalEquity, ok: near(totalAssets, totalLiabs+totalEquity)};
    },
    cashFlowIndirect(start,end){
      const is = this.incomeStatement(start,end);
      const netIncome = is.net;
      // Non-cash approx: add Depreciation Expense delta
      const deprecAcc = state.accounts.find(a=>a.name==='Depreciation Expense');
      const nonCash = deprecAcc ? balanceDelta(deprecAcc.id,start,end) : 0;

      // Working capital: ΔAR + ΔInventory + ΔPrepaid - ΔAP - ΔAccrued
      const delta = name => {
        const acc = state.accounts.find(a=>a.name===name);
        return acc ? (balanceOf(acc.id,end)-balanceOf(acc.id,start)) : 0;
      };
      const workingCapital = (delta('Accounts Receivable') + delta('Inventory') + delta('Prepaid Expenses')) - (delta('Accounts Payable') + delta('Accrued Expenses'));

      const cfo = netIncome + nonCash - workingCapital;

      // Capex approx: negative increase to PPE (asset increase is cash out)
      const dPPE = delta('PPE');
      const capex = dPPE>0 ? dPPE : 0; // increase in PPE => cash out
      const cfi = -capex;

      // Financing: Δ(Short-term Debt + Long-term Debt + Owner’s Equity) except retained earnings (net income already in NI)
      const finNames = ['Short-term Debt','Long-term Debt','Owner’s Equity'];
      const finDelta = finNames.reduce((s,n)=>s+delta(n),0);
      const cff = finDelta;

      const netChange = cfo + cfi + cff;
      return { netIncome, nonCash, workingCapital, cfo, capex, cfi, cff, netChange };
    }
  };

  /* ---------- AI Layer ---------- */

  function aiRuleBased(){
    const s = calc.snap();
    const list = [];
    // BS balance
    list.push({topic:'Balance Sheet Balance', detail: (s.assets).toFixed(2)+' vs '+(s.liabs+s.equity).toFixed(2), severity: near(s.assets,s.liabs+s.equity)?'ok':'warn'});
    // Profitability
    list.push({topic:'Profitability', detail:`Net: ${fmt(s.net)}; Gross: ${fmt(s.revenue - s.cogs)}`, severity: s.net>=0?'ok':'warn'});
    // Liquidity
    const cr = calc.currentRatio();
    list.push({topic:'Liquidity', detail:`Current Ratio: ${cr.toFixed(2)}`, severity: cr>=1.2?'ok':'warn'});
    // Leverage
    const dte = calc.debtToEquity();
    list.push({topic:'Leverage', detail:`Debt/Equity: ${isFinite(dte)?dte.toFixed(2):'∞'}`, severity: dte<=2?'ok':'warn'});
    // Cash sanity: cash change ~ net cash flow
    const cashIds = state.accounts.filter(a=>['Cash','Bank'].includes(a.name)).map(a=>a.id);
    const cashBal = sum(cashIds.map(id=>balanceOf(id)));
    list.push({topic:'Cash Level', detail:`Cash & Bank: ${fmt(cashBal)}`, severity: cashBal>=0?'ok':'warn'});
    return list;
  }

  async function cloudAI(){
    const {endpoint, model, key} = state.ai;
    if(!endpoint || !model || !key){ alert('Add API endpoint, model, and key in Settings.'); return; }
    const start = val('rStart') || '1900-01-01', end = val('rEnd') || today();
    const bs = calc.balanceSheet(end), is = calc.incomeStatement(start,end), cf = calc.cashFlowIndirect(start,end);
    const summary = {
      org: state.org.bookName, period:{start,end},
      BS:{assets:bs.assets,totalAssets:bs.totalAssets, liabilities:bs.liabs, equity:bs.equity, totalLiabilities:bs.totalLiabs, totalEquity:bs.totalEquity, ok:bs.ok},
      IS:is, CF:cf, ratios:{ currentRatio:calc.currentRatio(), debtToEquity:calc.debtToEquity() }
    };
    const prompt = (byId('aiAsk').value || 'Give me an investor-style summary, key risks, and 3 action items.')
      + '\n\nHere is a compact JSON of the statements:\n' + JSON.stringify(summary);

    byId('aiOut').textContent = 'Thinking…';
    try{
      // Default to OpenAI-compatible schema
      const res = await fetch(endpoint, {
        method:'POST',
        headers:{ 'Content-Type':'application/json', 'Authorization':'Bearer '+key },
        body: JSON.stringify({
          model,
          messages:[{role:'system', content:'You are a senior financial analyst. Be concise and practical.'},
                    {role:'user', content: prompt}],
          temperature:0.2
        })
      });
      if(!res.ok){ throw new Error('HTTP '+res.status); }
      const json = await res.json();
      const text = json.choices?.[0]?.message?.content || JSON.stringify(json,null,2);
      byId('aiOut').textContent = text.trim();
    }catch(err){
      byId('aiOut').textContent = 'AI request failed: '+err.message;
    }
  }

  /* ---------- Journal UI ---------- */

  function initNewJE(){
    setVal('jeDate', today());
    setVal('jeMemo','');
    byId('jeLines').innerHTML = '';
    addJELine(); addJELine();
    updateJE();
  }

  function addJELine(line){
    const idx = byId('jeLines').children.length;
    const div = document.createElement('div');
    div.className = 'grid cols-3';
    div.innerHTML = `
      <div><select data-k="accountId">${state.accounts.map(a=>`<option value="${a.id}">${escapeHTML(a.name)} (${a.type[0]})</option>`).join('')}</select></div>
      <div><input data-k="debit" type="number" step="0.01" min="0" placeholder="Debit"></div>
      <div class="flex">
        <input data-k="credit" type="number" step="0.01" min="0" placeholder="Credit">
        <button class="btn danger" onclick="this.closest('.grid').remove(); updateJE()">✖</button>
      </div>`;
    byId('jeLines').appendChild(div);
    Array.from(div.querySelectorAll('input,select')).forEach(el=>el.addEventListener('input',updateJE));
    if(line){ div.querySelector('[data-k="accountId"]').value = line.accountId; setValEl(div.querySelector('[data-k="debit"]'), line.debit); setValEl(div.querySelector('[data-k="credit"]'), line.credit); }
  }

  function updateJE(){
    const lines = getCurrentLines();
    const d = sum(lines.map(l=>l.debit)), c = sum(lines.map(l=>l.credit));
    byId('jeBalance').textContent = (d-c).toFixed(2);
    byId('jeBalance').style.color = near(d,c) ? 'var(--ok)' : 'var(--danger)';
  }

  function getCurrentLines(){
    return Array.from(byId('jeLines').children).map(row=>{
      return {
        accountId: +row.querySelector('[data-k="accountId"]').value,
        debit: num(row.querySelector('[data-k="debit"]').value),
        credit: num(row.querySelector('[data-k="credit"]').value)
      };
    }).filter(l => l.debit>0 || l.credit>0);
  }

  function saveJE(){
    const date = val('jeDate'), memo = val('jeMemo');
    const lines = getCurrentLines();
    if(!date) return alert('Date required');
    const d = sum(lines.map(l=>l.debit)), c = sum(lines.map(l=>l.credit));
    if(!near(d,c)) return alert('Entry not balanced');
    if(!lines.length) return alert('Add at least one line');
    postJE(date,memo,lines);
    save(); render.journals(); render.dashboard();
    alert('Posted ✔️');
    initNewJE();
  }

  function uiEdit(id){
    const e = state.entries.find(x=>x.id===id); if(!e) return;
    ui.goto('journals');
    setVal('jeDate', e.date); setVal('jeMemo', e.memo||'');
    byId('jeLines').innerHTML = '';
    e.lines.forEach(l=>addJELine(l)); updateJE();
    // replace on save
    ui.saveJE = function(){
      const lines = getCurrentLines();
      const d = sum(lines.map(l=>l.debit)), c = sum(lines.map(l=>l.credit));
      if(!near(d,c)) return alert('Entry not balanced');
      Object.assign(e, { date: val('jeDate'), memo: val('jeMemo'), lines });
      save(); render.journals(); render.dashboard();
      alert('Updated ✔️'); initNewJE(); ui.saveJE = saveJE; // restore
    };
  }

  function uiDelete(id){
    if(!confirm('Delete entry #'+id+'?')) return;
    const i = state.entries.findIndex(e=>e.id===id);
    if(i>=0){ state.entries.splice(i,1); save(); render.journals(); render.dashboard(); }
  }

  function postJE(date,memo,lines){
    state.entries.push({ id: state.seq.je++, date, memo, lines: lines.map(l=>({accountId:+l.accountId, debit:+(+l.debit||0), credit:+(+l.credit||0)})) });
  }

  /* ---------- Import / Export ---------- */

  async function importFile(){
    const file = byId('fileInput').files[0]; if(!file) return alert('Choose a file');
    const text = await file.text();
    if(file.name.endsWith('.json')){
      const obj = JSON.parse(text);
      // minimal validation
      if(!obj.accounts || !obj.entries) return alert('Invalid JSON structure');
      Object.assign(state, obj); save(); ui.goto('dashboard');
      alert('Imported JSON ✔️');
    }else{
      // CSV
      Papa.parse(text, {
        header:true, skipEmptyLines:true,
        complete: res => {
          // group by (date,memo)
          const groups = {};
          res.data.forEach(r=>{
            const key = (r.date||'')+'|'+(r.memo||'');
            groups[key] = groups[key] || [];
            const acc = getOrCreateAccount((r.account||'').trim());
            groups[key].push({ accountId: acc.id, debit: num(r.debit), credit: num(r.credit) });
          });
          Object.entries(groups).forEach(([k,lines])=>{
            const [date,memo] = k.split('|');
            if(!date) return;
            const d = sum(lines.map(l=>l.debit)), c = sum(lines.map(l=>l.credit));
            if(!near(d,c)) console.warn('Unbalanced imported entry', date,memo);
            postJE(date, memo, lines);
          });
          save(); ui.goto('dashboard'); alert('Imported CSV ✔️');
        }
      });
    }
  }

  function getOrCreateAccount(name){
    let acc = state.accounts.find(a=>a.name.toLowerCase()===name.toLowerCase());
    if(acc) return acc;
    // heuristics to type
    let type='Expense';
    if(/cash|bank|asset|ppe|receivable|inventory|prepaid/i.test(name)) type='Asset';
    else if(/payable|debt|loan|liabil/i.test(name)) type='Liability';
    else if(/equity|capital|retained/i.test(name)) type='Equity';
    else if(/revenue|sales|income/i.test(name)) type='Revenue';
    else if(/cogs|cost of goods/i.test(name)) type='COGS';
    data.addAccount(name,type);
    return state.accounts[state.accounts.length-1];
  }

  /* ---------- Helpers ---------- */

  function L(accountId,debit,credit){ return {accountId,debit,credit}; }
  function val(id){ return byId(id).value; }
  function setVal(id,v){ byId(id).value=v; }
  function setValEl(el,v){ el.value=v; }
  function byId(id){ return document.getElementById(id); }
  function sum(arr){ return arr.reduce((a,b)=>a+(+b||0),0); }
  function near(a,b,eps=0.005){ return Math.abs(a-b)<eps; }
  function num(x){ const n = +x; return isFinite(n)?n:0; }
  function fmt(n){ const s = (n||0); return (s<0?'-':'') + Intl.NumberFormat(undefined,{minimumFractionDigits:2,maximumFractionDigits:2}).format(Math.abs(s)); }
  function today(){ const d=new Date(); return d.toISOString().slice(0,10); }
  function escapeHTML(s){ return (s||'').replace(/[&<>"']/g,m=>({ '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;' }[m])); }
  function table2(rows){
    return `<table>${rows.map(r=>Array.isArray(r)?`<tr><td>${r[0]}</td><td class="right">${r[1]}</td></tr>`:``).join('')}</table>`;
  }
  function rowsFromMap(obj){ return Object.entries(obj).map(([k,v])=>[k,fmt(v)]); }

  function balanceDelta(accountId,start,end){
    return balanceOf(accountId,end) - balanceOf(accountId,start);
  }

  function mapType(type, asOf){
    const o={}; state.accounts.filter(a=>a.type===type).forEach(a=>o[a.name]=balanceOf(a.id,asOf));
    return o;
  }

  function healthChecks(){
    const tb = calc.trialBalance();
    const okTB = near(tb.totalD,tb.totalC);
    const bs = calc.balanceSheet(today());
    const okBS = bs.ok;
    const cr = calc.currentRatio();
    return [
      {msg:'Trial balance equals', ok:okTB},
      {msg:'Assets = Liabilities + Equity', ok:okBS},
      {msg:'Current ratio ≥ 1.2', ok:cr>=1.2}
    ];
  }

  function save(){ localStorage.setItem(storeKey, JSON.stringify(state)); }
  function download(name,content){
    const a=document.createElement('a'); a.href=URL.createObjectURL(new Blob([content],{type:'text/plain'}));
    a.download=name; a.click(); setTimeout(()=>URL.revokeObjectURL(a.href),1000);
  }

  /* ---------- Global UI wiring ---------- */
  document.getElementById('menuBtn').onclick = ()=> document.getElementById('sidebar').classList.toggle('show');
  document.getElementById('reset').onclick = ()=>{
    if(confirm('Clear all local data?')){ localStorage.removeItem(storeKey); location.reload(); }
  };
  document.addEventListener('keydown',e=>{
    if(e.key==='/' && !/input|textarea|select/i.test(document.activeElement.tagName)){ e.preventDefault(); commandPalette(); }
  });

  function commandPalette(){
    const cmd = prompt('Command (e.g., "new", "reports", "load sample")');
    if(!cmd) return;
    const c = cmd.toLowerCase();
    if(c.includes('new')) ui.newEntry();
    else if(c.includes('report')) ui.goto('reports');
    else if(c.includes('sample')) data.loadSample();
    else if(c.includes('ai')) ui.goto('ai');
    else alert('Commands: new, reports, load sample, ai');
  }

  // init
  data.init();

  // default report period (this month)
  const d = new Date(); const first = new Date(d.getFullYear(), d.getMonth(), 1).toISOString().slice(0,10);
  const last = new Date(d.getFullYear(), d.getMonth()+1, 0).toISOString().slice(0,10);
  setVal('rStart',first); setVal('rEnd',last);

  // expose for devtools
  window.state = state; window.ui = ui; window.data = data;

  </script>
<footer>
    <p>&copy; 2025 Dank Accounting AI. All rights reserved.</p>
    <p>Founder & CEO: Aman Kumar | CFO: Prateek Upadhyay</p>
</footer>
</body>
</html>


