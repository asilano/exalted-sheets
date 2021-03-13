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

const field_int = (field) => parseInt(field.value) || 0;
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

function parry() {
  var ability = 'brawl'
  var defence = 0
  var wielded = $('.weapon-fields .wielded input:checked')
  if (wielded.length > 0)
  {
    var weapon = wielded[0].closest('.weapon-fields')
    ability = ability_from_tags(weapon.querySelector('.tags input').value)
    defence = field_int(weapon.querySelector('.defence input'))
  }

  var dexterity = field_int($('#character_dexterity')[0])
  var abil_score = field_int($('#character_' + ability)[0])
  return Math.ceil((dexterity + abil_score) / 2) + defence
}

function evasion() {
  var dexterity = field_int($('#character_dexterity')[0])
  var dodge = field_int($('#character_dodge')[0])
  return Math.ceil((dexterity + dodge) / 2)
}

function guile() {
  var manipulation = field_int($('#character_manipulation')[0])
  var socialise = field_int($('#character_socialise')[0])
  return Math.ceil((manipulation + socialise) / 2)
}

function resolve() {
  var wits = field_int($('#character_wits')[0])
  var integrity = field_int($('#character_integrity')[0])
  return Math.ceil((wits + integrity) / 2)
}

function rush_d() {
  var dexterity = field_int($('#character_dexterity')[0])
  var athletics = field_int($('#character_athletics')[0])
  return (dexterity + athletics) + "d"
}

function disengage_d() {
  var dexterity = field_int($('#character_dexterity')[0])
  var dodge = field_int($('#character_dodge')[0])
  return (dexterity + dodge) + "d"
}

function join_d() {
  var wits = field_int($('#character_wits')[0])
  var awareness = field_int($('#character_awareness')[0])
  return (wits + awareness) + 'd'
}

function ability_from_tags(tags) {
  for (var abil of ['brawl', 'melee', 'martial_arts']) {
    if (tags.toLowerCase().includes(abil.replaceAll('_', ' ')))
      return abil
  }
}

const utils = {
  'personal_pool': personal_pool,
  'periph_pool':   periph_pool,
  'nat_soak':      nat_soak,
  'soak':          soak,
  'parry':         parry,
  'evasion':       evasion,
  'guile':         guile,
  'resolve':       resolve,
  'rush_d':        rush_d,
  'disengage_d':   disengage_d,
  'join_d':        join_d
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

function next_damage() {
  const values = ['ok', 'bashing', 'lethal', 'aggravated']
  var field = this.nextSibling
  var old_val = field.value
  var old_ix = values.indexOf(old_val)
  var new_val = values[(old_ix + 1) % values.length]

  field.value = new_val
  this.innerHTML = new_val[0].toUpperCase()
}

document.addEventListener('turbolinks:load', () => {
  // $('#character_spark')[0].addEventListener('change', recalc)
  // for (var elem of $('[data-recalc]'))
  //   elem.addEventListener('change', recalc)
  // for (var elem of $('input, select'))
  //   elem.addEventListener('change', recalc)
  $('form').addEventListener('change', recalc)
  $('form').addEventListener('cocoon:after-insert', recalc)
  $('form').addEventListener('cocoon:after-remove', recalc)

  for (var elem of $('.damaged'))
    elem.addEventListener('click', next_damage)
})
