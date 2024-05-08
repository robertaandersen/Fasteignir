import React, { useEffect, useState } from "react";
import "./index.css";
import "react-tabulator/lib/styles.css";
import { ReactTabulator } from "react-tabulator";
import "react-tabulator/lib/styles.css"; // required styles
import "react-tabulator/lib/css/tabulator.min.css"; // theme
import { ApiConfig, Kaupskra, columns } from "./CustomTypes";

let apiConfig: ApiConfig = {
  // host: "http://external-alb-1426860325.eu-west-1.elb.amazonaws.com",
  host: "http://localhost:5063",
  api: "api",
  service: "Kaupskra",
};

function Api(param: string) {
  return `${apiConfig.host}/${apiConfig.api}/${apiConfig.service}?${param}`;
}

function getQueryParams(): string {
  const inputElements = document.getElementsByTagName("input");
  const inputs: { id: string; value: string }[] = [];
  for (let i = 0; i < inputElements.length; i++) {
    const input = inputElements[i] as HTMLInputElement;
    if (input.value !== "") {
      inputs.push({ id: input.id, value: input.value });
    }
  }
  const queryParams = inputs
    .map((input) => `${input.id}=${encodeURIComponent(input.value)}`)
    .join("&");
  console.log(queryParams);
  return queryParams === ""
    ? "postNumer=101%2C%20102%2C%20103%2C%20104%2C%20105%2C%20106%2C%20107%2C%20108%2C%20109%2C%20110%2C%20111%2C%20112&thinglystFra=2023-12-31T13%3A00"
    : queryParams;
}

function App() {
  const [kaupskra, setKaupskra] = useState<Kaupskra[]>([]);
  const [search, setSearch] = useState<string>(getQueryParams());
  useEffect(() => {
    async function fetchData() {
      try {
        const response = await fetch(Api(search));
        const data = await response.json();
        setKaupskra(data);
      } catch (err) {
        console.log(err);
      }
    }
    fetchData();
  }, [search]);

  let timeout: NodeJS.Timeout | null = null;

  function handleInputChange(input: HTMLInputElement) {
    if (timeout) {
      clearTimeout(timeout);
    }

    timeout = setTimeout(() => {
      if (input.type === "text" && input.value.length < 3) {
        return;
      }
      const inputs: { id: string; value: string }[] = [];
      // Inside the handleInputChange function
      const queryParams = getQueryParams();
      setKaupskra([]);
      setSearch(queryParams);
    }, 1000);
  }
  return (
    <div>
      <div className="input">
        <div>
          <input
            type="text"
            placeholder="Name"
            onChange={(e) => handleInputChange(e.target)}
            id="name"
          />
          <input
            type="text"
            placeholder="Post Numer"
            onChange={(e) => handleInputChange(e.target)}
            id="postNumer"
            defaultValue={
              "101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112"
            }
          />
          <input
            type="number"
            placeholder="Fermetrar Fra"
            onChange={(e) => handleInputChange(e.target)}
            id="fermetrarFra"
          />
          <input
            type="number"
            placeholder="Fermetrar Til"
            onChange={(e) => handleInputChange(e.target)}
            id="fermetrarTil"
          />
          <input
            type="number"
            placeholder="Kaupverd Fra"
            onChange={(e) => handleInputChange(e.target)}
            id="kaupverdFra"
          />
          <input
            type="number"
            placeholder="Kaupverd Til"
            onChange={(e) => handleInputChange(e.target)}
            id="kaupverdTil"
          />
          <input
            type="number"
            placeholder="Herbergi Fra"
            onChange={(e) => handleInputChange(e.target)}
            id="herbergiFra"
          />
          <input
            type="number"
            placeholder="Herbergi Til"
            onChange={(e) => handleInputChange(e.target)}
            id="herbergiTil"
          />
          <input
            type="datetime-local"
            placeholder="Thinglyst Fra"
            onChange={(e) => handleInputChange(e.target)}
            id="thinglystFra"
            defaultValue="2023-12-31T13:00"
          />
          <input
            type="datetime-local"
            placeholder="Thinglyst Til"
            onChange={(e) => handleInputChange(e.target)}
            id="thinglystTil"
          />
          <input
            type="number"
            placeholder="Byggingar Fra"
            onChange={(e) => handleInputChange(e.target)}
            id="byggingarFra"
          />
          <input
            type="number"
            placeholder="Byggingar Til"
            onChange={(e) => handleInputChange(e.target)}
            id="byggingarTil"
          />
        </div>
      </div>
      <div className="table">
        <br />
        Leitin skilar að hámarki 100 niðurstöðum
        <br />
        <br />
      </div>
      <ReactTabulator data={kaupskra} columns={columns} layout={"fitData"} />
    </div>
  );
}

export default App;
