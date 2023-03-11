import { PageHeader } from "antd";
import React from "react";

// displays a page header

export default function Header() {
  return (
    <a href="/" rel="noopener noreferrer">
      <PageHeader title="⚽ MFF Soccer" subTitle="XChain Contract" style={{ cursor: "pointer" }} />
    </a>
  );
}
