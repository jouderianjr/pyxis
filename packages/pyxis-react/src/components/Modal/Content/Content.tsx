import { FC, ReactNode } from 'react';

const Content: FC<ContentProps> = ({ children }) => (
  <div className="modal__content">{children}</div>
);
export default Content;

export interface ContentProps {
  children: ReactNode;
}
