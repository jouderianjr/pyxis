import { render, screen } from '@testing-library/react';
import Content from './Content';

describe('Modal.Content component', () => {
  test('it should render content', () => {
    render(<Content>Some Text</Content>);
    const content = screen.getByText('Some Text');
    expect(content).toBeInTheDocument();
  });
});
