import React from "react";
import Checkbox from "./Checkbox";

export default function Subject(props) {
  const { subject } = props;

  return <div className="mdc-list-item growing-text-list">
    <a className="mdc-list-item__text" href={subject.path}>
      {subject.name}
    </a>

    <span className="mdc-list-item__meta two-checkboxes">
      <Checkbox checked={subject.course_approved} />

      {
        subject.has_exam && <Checkbox checked={subject.exam_approved} disabled={!subject.can_enroll_to_exam} />
      }
    </span>
  </div>;
}
