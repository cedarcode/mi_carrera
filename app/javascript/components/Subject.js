import React from "react";

export default function Subject(props) {
  const { subject } = props;

  return <div className="mdc-list-item growing-text-list">
    <a className="mdc-list-item__text" href={subject.url}>
      {subject.name}
    </a>

    <span className="mdc-list-item__meta two-checkboxes">
      <input type="checkbox" checked={subject.course_approved}/>

      {
        subject.has_exam && <input type="checkbox" checked={subject.exam_approved} disabled={!subject.can_enroll_to_exam}/>
      }
    </span>
  </div>;
}
