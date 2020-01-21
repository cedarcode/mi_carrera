import React from "react";

export default function Bedel(props) {
  return <div className="mdc-list">
    {
      props.subjects.map((subject, index) => (
        <p key={index}>{subject.name}</p>
      ))
    }
  </div>;
}
