import React, {FC} from "react";
import OverviewTemplate from "./utils/OverviewTemplate";
import Banner from "./assets/banner.png";

const Introduction: FC = () => (
  <>
    <OverviewTemplate title="Pyxis Design System" category="Introduction" isMain>
      <img src={Banner} alt="Pyxis Design System" className="margin-b-m full-width"/>
      <p>
        Pyxis is Prima's Design System. A collection of tools, rules and guidelines to design, develop and tell our brand.
      </p>
      <p>
        A unique resource to work in harmony and improve the user and customer experience.
      </p>
    </OverviewTemplate>
  </>
);

export default Introduction;
