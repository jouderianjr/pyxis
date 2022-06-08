import { render, screen, fireEvent } from '@testing-library/react';
import { IconClock } from 'components/Icon/Icons';
import Header from './Header';

describe('Modal.Header component', () => {
  test('does not have sticky class when no isSticky prop passed', () => {
    render(<Header id="header" />);
    const header = screen.getByRole('banner');
    expect(header).not.toHaveClass('modal__header--sticky');
  });
  test('has sticky class when isSticky prop passed', () => {
    render(<Header id="header" isSticky />);
    const header = screen.getByRole('banner');
    expect(header).toHaveClass('modal__header--sticky');
  });
  test('does not have custom class when has no children', () => {
    render(<Header id="modal-header" />);
    const headerWrapper = screen.getByTestId('modal-header-wrapper');
    expect(headerWrapper).not.toHaveClass('modal__header__wrapper--custom');
  });
  test('has custom class when has children', () => {
    render(<Header id="modal-header">Test child content</Header>);
    const headerWrapper = screen.getByTestId('modal-header-wrapper');
    expect(headerWrapper).toHaveClass('modal__header__wrapper--custom');
  });
  test('has id passed', () => {
    render(<Header id="testId" />);
    const header = screen.getByRole('banner');
    expect(header).toHaveAttribute('id', 'testId');
  });
  test('renders children content', () => {
    render(<Header id="header">Test child content</Header>);
    const header = screen.getByText('Test child content');
    expect(header).toBeInTheDocument();
  });
  test('renders badge when passed', () => {
    const badge = <span data-testid="badge">Test Badge</span>;
    render(<Header badge={badge} id="header" />);
    expect(screen.getByTestId('badge')).toBeInTheDocument();
  });
  test('renders icon when passed', () => {
    render(<Header icon={<IconClock description="Clock Icon" />} id="header" />);
    expect(screen.getByLabelText('Clock Icon')).toBeInTheDocument();
  });
  test('renders title when passed', () => {
    render(<Header id="header" title="Test title text" />);
    expect(screen.getByText('Test title text')).toBeInTheDocument();
  });
  test('can render title, icon and badge together', () => {
    render(
      <Header
        badge={<span data-testid="badge">Test Badge</span>}
        icon={<IconClock description="Clock Icon" />}
        id="header"
        title="Test title text"
      />,
    );
    expect(screen.getByText('Test title text')).toBeInTheDocument();
    expect(screen.getByLabelText('Clock Icon')).toBeInTheDocument();
    expect(screen.getByTestId('badge')).toBeInTheDocument();
  });
  test('renders children instead of title, icon and badge when passed', () => {
    render(
      <Header
        badge={<span data-testid="badge">Test Badge</span>}
        icon={<IconClock description="Clock Icon" />}
        id="modal-header"
        title="Test title text"
      >
        Test child content
      </Header>,
    );
    expect(screen.queryByText('Test title text')).not.toBeInTheDocument();
    expect(screen.queryByLabelText('Clock Icon')).not.toBeInTheDocument();
    expect(screen.queryByTestId('badge')).not.toBeInTheDocument();
    expect(screen.getByTestId('modal-header-wrapper')).toHaveTextContent(
      'Test child content',
    );
  });
  test('does not display close button without callback', () => {
    render(<Header id="modal-header" />);
    expect(screen.queryByLabelText('close')).not.toBeInTheDocument();
  });
  test('calls onClose callback when close button clicked', () => {
    const closeCb = jest.fn();
    render(<Header id="header" onClose={closeCb} />);
    fireEvent.click(screen.getByLabelText('close'));
    expect(closeCb).toBeCalled();
  });
  test('can customize close button text', () => {
    const closeCb = jest.fn();
    render(<Header closeLabel="test-close-label" id="header" onClose={closeCb} />);
    expect(screen.getByLabelText('test-close-label')).toBeInTheDocument();
    fireEvent.click(screen.getByLabelText('test-close-label'));
    expect(closeCb).toBeCalled();
  });
});
