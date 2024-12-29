import type { TOC } from '@ember/component/template-only';
import NavSubLink from 'jikan-da/components/nav/sub-link';

const NavLinks: TOC<object> = <template>
  <ul class="menu" ...attributes>
    <li>
      <a href="/">Home</a>
    </li>
    <li>
      <a href="/time-tracking">Time Tracking</a>
    </li>
    <li>
      <a href="/charge-codes">Chage Codes</a>
    </li>
    <li>
      <NavSubLink @burgerMenu={{@burgerMenu}} />
    </li>
  </ul>
</template>;

export default NavLinks;
