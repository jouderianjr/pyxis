import React, {FC, ReactNode} from 'react';
import styles from './OverviewTemplate.module.scss';
import {pascalToKebab} from 'commons/utils/string';

const OverviewTemplate: FC<AllStoriesOverviewGeneratorProps> = (
  {
    title,
    description,
    category,
    children,
    isMain,
  },
) => (
  <div className={styles.wrapper}>
    <div className={styles.header}>
      {category && isMain && <div className={styles.category}>{category}</div>}
      <h2 className={isMain ? styles.mainTitle : styles.title} id={pascalToKebab(title)}>{title}</h2>
    </div>

    {description && <div className={styles.description}>
      {description}
    </div>}

    {children}
  </div>
);

export default OverviewTemplate;

interface AllStoriesOverviewGeneratorProps {
  children?: ReactNode;
  description?: ReactNode;
  title: string;
  category?: string;
  isMain?: boolean;
}
