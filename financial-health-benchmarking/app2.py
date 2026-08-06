import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
import streamlit as st

# ---------------- PAGE CONFIG ----------------
st.set_page_config(
    page_title="IT Services Financial Benchmark",
    layout="wide",
    initial_sidebar_state="expanded",
)

# ---------------- DATA SETUP ----------------
years = ["FY2021", "FY2022", "FY2023", "FY2024", "FY2025"]

data = {
    "TCS": {
        "Revenue": [164177, 191754, 225458, 240893, 255324],
        "Net Profit": [32562, 38449, 42303, 46099, 48797],
        "Operating Margin": [28, 28, 26, 27, 26],
        "ROE": [37.66, 43.14, 46.78, 50.94, 51.50],
        "Debt to Equity": [0.090, 0.088, 0.085, 0.089, 0.099],
        "EPS": [87.67, 104.75, 115.19, 126.88, 134.20],
    },
    "Infosys": {
        "Revenue": [100472, 121641, 146767, 153670, 162990],
        "Net Profit": [19423, 22146, 24108, 26248, 26750],
        "Operating Margin": [28, 26, 24, 24, 24],
        "ROE": [25.44, 29.39, 31.97, 29.79, 27.92],
        "Debt to Equity": [0.070, 0.073, 0.110, 0.095, 0.086],
        "EPS": [45.42, 52.56, 58.08, 63.20, 64.32],
    },
    "Wipro": {
        "Revenue": [61935, 79312, 90488, 89760, 89088],
        "Net Profit": [10868, 12243, 11366, 11112, 13218],
        "Operating Margin": [24, 21, 19, 19, 20],
        "ROE": [19.80, 18.72, 14.64, 14.91, 16.05],
        "Debt to Equity": [0.190, 0.269, 0.225, 0.221, 0.233],
        "EPS": [9.85, 11.15, 10.34, 10.57, 12.54],
    },
}

# Corporate Color Palette
COLORS = {"TCS": "#1E3A8A", "Infosys": "#0284C7", "Wipro": "#0D9488"}

rows = []
for company, d in data.items():
  for i, yr in enumerate(years):
    rows.append({
        "Company": company,
        "Year": yr,
        "Revenue": d["Revenue"][i],
        "Net Profit": d["Net Profit"][i],
        "Operating Margin": d["Operating Margin"][i],
        "ROE": d["ROE"][i],
        "Debt to Equity": d["Debt to Equity"][i],
        "EPS": d["EPS"][i],
    })
df = pd.DataFrame(rows)

# ---------------- HEADER ----------------
st.title("IT Services Financial Intelligence")
st.subheader("5-Year Comparative Performance (FY2021 – FY2025)")
st.caption(
    "Data Source: Screener.in Consolidated Audited Financial Statements"
)
st.divider()

# ---------------- SIDEBAR CONTROLS ----------------
st.sidebar.title("Filter Options")
selected_companies = st.sidebar.multiselect(
    "Select Companies", list(data.keys()), default=list(data.keys())
)
selected_metric = st.sidebar.selectbox(
    "Primary Metric View",
    ["Revenue", "Net Profit", "Operating Margin", "ROE", "Debt to Equity", "EPS"],
    index=0,
)
year_range = st.sidebar.select_slider(
    "Select Period", options=years, value=(years[0], years[-1])
)

# Apply Filters
filtered = df[df["Company"].isin(selected_companies)]
start_idx, end_idx = years.index(year_range[0]), years.index(year_range[1])
filtered = filtered[filtered["Year"].isin(years[start_idx : end_idx + 1])]

# ---------------- KPI CARDS ----------------
st.write("**FY2025 Financial Summary**")
if selected_companies:
  cols = st.columns(len(selected_companies))
  for i, company in enumerate(selected_companies):
    latest = df[(df["Company"] == company) & (df["Year"] == "FY2025")].iloc[0]
    prev = df[(df["Company"] == company) & (df["Year"] == "FY2024")].iloc[0]
    rev_growth = ((latest["Revenue"] - prev["Revenue"]) / prev["Revenue"]) * 100

    with cols[i]:
      st.metric(
          label=f"{company} Revenue (FY25)",
          value=f"₹{latest['Revenue']:,} Cr",
          delta=f"{rev_growth:+.1f}% YoY",
      )
      st.metric(label=f"{company} ROE", value=f"{latest['ROE']:.1f}%")
      st.metric(
          label=f"{company} OPM", value=f"{latest['Operating Margin']:.0f}%"
      )

st.divider()

# ---------------- TABS FOR BETTER ORGANIZATIONAL FLOW ----------------
tab1, tab2, tab3 = st.tabs(
    ["Trend Analysis", "5-Year Cumulative Growth", "Raw Financial Data"]
)

with tab1:
  st.write(f"**{selected_metric} Trajectory ({year_range[0]} – {year_range[1]})**")
  fig = go.Figure()
  for company in selected_companies:
    sub = filtered[filtered["Company"] == company]
    fig.add_trace(go.Scatter(
        x=sub["Year"],
        y=sub[selected_metric],
        mode="lines+markers",
        name=company,
        line=dict(color=COLORS[company], width=2.5),
        marker=dict(size=7),
    ))

  fig.update_layout(
      template="plotly_white",
      height=400,
      margin=dict(l=20, r=20, t=20, b=20),
      hovermode="x unified",
      legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="right", x=1),
      xaxis=dict(showgrid=True, gridcolor="#E2E8F0"),
      yaxis=dict(showgrid=True, gridcolor="#E2E8F0"),
  )
  st.plotly_chart(fig, use_container_width=True)

with tab2:
  col1, col2 = st.columns(2)

  with col1:
    st.write("**5-Year Revenue Growth (%)**")
    growth_rows = []
    for company in selected_companies:
      rev21 = data[company]["Revenue"][0]
      rev25 = data[company]["Revenue"][-1]
      growth_rows.append({
          "Company": company,
          "Growth %": round((rev25 - rev21) / rev21 * 100, 1),
      })
    gdf = pd.DataFrame(growth_rows)

    fig2 = px.bar(
        gdf,
        x="Company",
        y="Growth %",
        color="Company",
        color_discrete_map=COLORS,
        text="Growth %",
    )
    fig2.update_traces(texttemplate="%{text}%", textposition="outside")
    fig2.update_layout(
        template="plotly_white",
        height=350,
        showlegend=False,
        margin=dict(l=20, r=20, t=20, b=20),
        yaxis=dict(showgrid=True, gridcolor="#E2E8F0"),
    )
    st.plotly_chart(fig2, use_container_width=True)

  with col2:
    st.write("**5-Year Net Profit Growth (%)**")
    profit_rows = []
    for company in selected_companies:
      p21 = data[company]["Net Profit"][0]
      p25 = data[company]["Net Profit"][-1]
      profit_rows.append(
          {"Company": company, "Growth %": round((p25 - p21) / p21 * 100, 1)}
      )
    pdf = pd.DataFrame(profit_rows)

    fig3 = px.bar(
        pdf,
        x="Company",
        y="Growth %",
        color="Company",
        color_discrete_map=COLORS,
        text="Growth %",
    )
    fig3.update_traces(texttemplate="%{text}%", textposition="outside")
    fig3.update_layout(
        template="plotly_white",
        height=350,
        showlegend=False,
        margin=dict(l=20, r=20, t=20, b=20),
        yaxis=dict(showgrid=True, gridcolor="#E2E8F0"),
    )
    st.plotly_chart(fig3, use_container_width=True)

with tab3:
  st.write("**Financial Metrics Data Table**")
  st.dataframe(
      filtered.reset_index(drop=True),
      use_container_width=True,
      hide_index=True,
  )
