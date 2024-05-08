export const columns = [
  { title: "Heimilisfang", field: "heimilisfang" },
  { title: "Postnr", field: "postnr", hozAlign: "center" },
  { title: "Sveitarfelag", field: "sveitarfelag" },

  { title: "Fastnum", field: "fastnum", hozAlign: "center" },
  { title: "Skjalanumer", field: "skjalanumer", hozAlign: "center" },

  { title: "Utgdag", field: "utgdag" },
  { title: "Thinglystdags", field: "thinglystdags" },
  { title: "Kaupverd", field: "kaupverd", hozAlign: "center" },
  { title: "Fasteignamat", field: "fasteignamat", hozAlign: "center" },
  {
    title: "FasteignamatGildandi",
    field: "fasteignamatGildandi",
    hozAlign: "center",
  },
  {
    title: "BrunabotamatGildandi",
    field: "brunabotamatGildandi",
    hozAlign: "center",
  },
  { title: "Byggar", field: "byggar", hozAlign: "center" },

  { title: "Einflm", field: "einflm", hozAlign: "center" },
  { title: "LodFlm", field: "lodFlm", hozAlign: "center" },
  { title: "LodFlmein", field: "lodFlmein" },
  { title: "Fjherb", field: "fjherb", hozAlign: "center" },
  { title: "Tegund", field: "tegund" },
  {
    title: "Fullbuid",
    field: "fullbuid",
    hozAlign: "center",
    formatter: "tickCross",
  },
  {
    title: "OnothaefurSamningur",
    field: "onothaefurSamningur",
    hozAlign: "center",
    formatter: "tickCross",
  },
];

export type ApiConfig = {
  host: string;
  api: string;
  service: string;
};

export type Kaupskra = {
  id: string;
  faerslunumer: number;
  emnr: number;
  skjalanumer: string;
  fastnum: number;
  heimilisfang: string;
  postnr: number;
  heinum: number;
  svfn: string;
  sveitarfelag: string;
  utgdag: string;
  thinglystdags: string;
  kaupverd: number;
  fasteignamat: number;
  fasteignamatGildandi: number;
  brunabotamatGildandi: number;
  byggar: number;
  fepilog: string;
  einflm: number;
  lodFlm: number;
  lodFlmein: string;
  fjherb: number;
  tegund: string;
  fullbuid: boolean;
  onothaefurSamningur: boolean;
};
