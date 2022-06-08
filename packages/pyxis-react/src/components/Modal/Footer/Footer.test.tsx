import { render, screen, within } from '@testing-library/react';
import Footer from './Footer';

describe('Modal.Footer component', () => {
  test('does not have sticky class when no isSticky prop passed', () => {
    render(<Footer id="footer" />);
    const footer = screen.getByRole('contentinfo');
    expect(footer).not.toHaveClass('modal__footer--sticky');
  });
  test('has sticky class when isSticky prop passed', () => {
    render(<Footer id="footer" isSticky />);
    const footer = screen.getByRole('contentinfo');
    expect(footer).toHaveClass('modal__footer--sticky');
  });
  test('has alt class when alt prop passed', () => {
    render(<Footer alt id="footer" />);
    const footer = screen.getByRole('contentinfo');
    expect(footer).toHaveClass('modal__footer--alt');
  });
  test('renders children content', () => {
    render(<Footer id="footer">Test child content</Footer>);
    const footer = screen.getByText('Test child content');
    expect(footer).toBeInTheDocument();
  });
  test('renders passed text', () => {
    render(<Footer id="modal-footer" text="test text" />);
    expect(screen.getByTestId('modal-footer-text')).toHaveTextContent(
      'test text',
    );
  });
  test('renders passed buttons', () => {
    const buttons = <button>Test Button</button>;
    render(<Footer buttons={buttons} id="modal-footer" />);
    expect(
      within(screen.getByTestId('modal-footer-buttons')).getByText(
        'Test Button',
      ),
    ).toBeInTheDocument();
  });
  test('can render both text and buttons', () => {
    render(
      <Footer
        buttons={<button>Test Button</button>}
        id="modal-footer"
        text="test text"
      />,
    );
    expect(screen.getByTestId('modal-footer-text')).toHaveTextContent(
      'test text',
    );
    expect(
      within(screen.getByTestId('modal-footer-buttons')).getByText(
        'Test Button',
      ),
    ).toBeInTheDocument();
  });
  test('renders children instead of text and buttons when passed', () => {
    render(
      <Footer
        buttons={<button>Test Button</button>}
        id="modal-footer"
        text="test text"
      >
        Test child content
      </Footer>,
    );
    expect(screen.queryByText('test text')).not.toBeInTheDocument();
    expect(
      screen.queryByTestId('modal-footer-buttons'),
    ).not.toBeInTheDocument();
    expect(screen.getByText('Test child content')).toBeInTheDocument();
  });
});
