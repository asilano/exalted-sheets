import { $ } from "@rails/ujs";

function personal_pool(spark) {
  const perm_ess = parseInt($('#character_permanent_ess')[0].value)
  if (spark === 'solar')
    return 10 + perm_ess * 3
  else if (spark === 'dragon_blooded')
    return 11 + perm_ess
}

function periph_pool(spark) {
  const perm_ess = parseInt($('#character_permanent_ess')[0].value)
  if (spark === 'solar')
    return 26 + perm_ess * 7
  else if (spark === 'dragon_blooded')
    return 23 + perm_ess * 4
}

const field_int = (field) => parseInt("0"+ field.value);
const sum = (total, val) => total + val;

function nat_soak() {
  return parseInt($('#character_stamina')[0].value)
}

function soak() {
  var armour_soak = 0
  var armour_fields = $('.armour-fields .soak input')
  if (armour_fields.length > 0)
    armour_soak = armour_fields.map(field_int).reduce(sum, 0)

  return parseInt($('#character_stamina')[0].value) + armour_soak
}

const utils = {
  'personal_pool': personal_pool,
  'periph_pool':   periph_pool,
  'nat_soak':      nat_soak,
  'soak':          soak
}


function recalc() {
  var spark = $('#character_spark')[0].value
  for (var elem of $('[data-spark]')) {
    elem.innerHTML = JSON.parse(elem.dataset['spark'])[spark]
  }

  for (elem of $('[data-spark-show]')) {
    if (elem.dataset['sparkShow'] === spark)
      elem.classList.remove('hidden')
    else
      elem.classList.add('hidden')
  }

  for (elem of $('[data-spark-fn]')) {
    var fn = utils[elem.dataset.sparkFn];
    if (typeof fn === "function")
      elem.value = fn(spark)
  }

  for (elem of $('[data-inner-html]')) {
    var fn = utils[elem.dataset.innerHtml];
    if (typeof fn === "function")
      elem.innerHTML = fn()
  }
}

document.addEventListener('turbolinks:load', () => {
  // $('#character_spark')[0].addEventListener('change', recalc)
  // for (var elem of $('[data-recalc]'))
  //   elem.addEventListener('change', recalc)
  // for (var elem of $('input, select'))
  //   elem.addEventListener('change', recalc)
  $('form')[0].addEventListener('change', recalc)
  $('form')[0].addEventListener('cocoon:after-insert', recalc)
  $('form')[0].addEventListener('cocoon:after-remove', recalc)
})
