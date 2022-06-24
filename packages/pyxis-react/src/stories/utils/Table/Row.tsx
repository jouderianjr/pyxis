import React, {FC, ReactNode} from 'react';
import shortid from 'shortid';
import styles from './Table.module.scss';

const Row: FC<RowProps> = ({ children, gridTemplateColumns }) => (
  <div className={styles.row} style={{ gridTemplateColumns }}>
    {children.map((child) => (
      <div className={styles.cell} key={shortid.generate()}>
        {child}
      </div>
    ))}
  </div>
);

export default Row;

interface RowProps {
  children: TableRow,
  gridTemplateColumns: string,
}

export type TableRow = TableCell[];
type TableCell = ReactNode;
