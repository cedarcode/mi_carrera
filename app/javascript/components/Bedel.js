import React from "react";

export default function Bedel(props) {
  return <div className="mdc-list-group subjects-list">
    {
      props.subjects.map((subject, index) => (
        <div className="mdc-list" key={index}>
          {subject.name}
        </div>
      ))
    }
  </div>;
}
