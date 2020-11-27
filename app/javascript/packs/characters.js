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

const utils = {
  'personal_pool': personal_pool,
  'periph_pool':   periph_pool
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
}

document.addEventListener('turbolinks:load', () => {
  $('#character_spark')[0].addEventListener('change', recalc)
  for (var elem of $('[data-recalc]'))
    elem.addEventListener('change', recalc)
})

