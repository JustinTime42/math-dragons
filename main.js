import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY

const supabase = supabaseUrl && supabaseKey
  ? createClient(supabaseUrl, supabaseKey)
  : null

// Email signup form
const emailForm = document.getElementById('email-form')
const emailStatus = document.getElementById('email-status')

emailForm.addEventListener('submit', async (e) => {
  e.preventDefault()
  const email = emailForm.email.value.trim()
  if (!email) return

  const btn = emailForm.querySelector('button')
  btn.disabled = true
  btn.textContent = 'Submitting...'
  emailStatus.textContent = ''
  emailStatus.className = 'form-status'

  if (!supabase) {
    emailStatus.textContent = 'Signup is not configured yet. Please try again later.'
    emailStatus.classList.add('error')
    btn.disabled = false
    btn.textContent = 'Join the Test'
    return
  }

  const { error } = await supabase.from('email_signups').insert({ email })

  if (error) {
    if (error.code === '23505') {
      emailStatus.textContent = "You're already signed up! We'll be in touch."
      emailStatus.classList.add('success')
    } else {
      emailStatus.textContent = 'Something went wrong. Please try again or email us directly.'
      emailStatus.classList.add('error')
    }
  } else {
    emailStatus.textContent = "You're in! We'll add you to the testing track and send instructions."
    emailStatus.classList.add('success')
    emailForm.reset()
  }

  btn.disabled = false
  btn.textContent = 'Join the Test'
})

// Feedback form
const feedbackForm = document.getElementById('feedback-form')
const feedbackStatus = document.getElementById('feedback-status')

feedbackForm.addEventListener('submit', async (e) => {
  e.preventDefault()
  const name = feedbackForm.name.value.trim()
  const email = feedbackForm.email.value.trim()
  const message = feedbackForm.message.value.trim()
  if (!message) return

  const btn = feedbackForm.querySelector('button')
  btn.disabled = true
  btn.textContent = 'Sending...'
  feedbackStatus.textContent = ''
  feedbackStatus.className = 'form-status'

  if (!supabase) {
    feedbackStatus.textContent = 'Feedback form is not configured yet. Please email us at support@routeworks.app.'
    feedbackStatus.classList.add('error')
    btn.disabled = false
    btn.textContent = 'Send Feedback'
    return
  }

  const row = { message }
  if (name) row.name = name
  if (email) row.email = email

  const { error } = await supabase.from('feedback').insert(row)

  if (error) {
    feedbackStatus.textContent = 'Something went wrong. Please email us at support@routeworks.app.'
    feedbackStatus.classList.add('error')
  } else {
    feedbackStatus.textContent = 'Thanks for the feedback! We read every message.'
    feedbackStatus.classList.add('success')
    feedbackForm.reset()
  }

  btn.disabled = false
  btn.textContent = 'Send Feedback'
})

// Mobile nav toggle
const navToggle = document.querySelector('.nav-toggle')
const navLinks = document.querySelector('.nav-links')

navToggle.addEventListener('click', () => {
  navLinks.classList.toggle('open')
  navToggle.classList.toggle('open')
})

// Close mobile nav on link click
navLinks.querySelectorAll('a').forEach(link => {
  link.addEventListener('click', () => {
    navLinks.classList.remove('open')
    navToggle.classList.remove('open')
  })
})

// Smooth scroll for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
  anchor.addEventListener('click', (e) => {
    const target = document.querySelector(anchor.getAttribute('href'))
    if (target) {
      e.preventDefault()
      target.scrollIntoView({ behavior: 'smooth', block: 'start' })
    }
  })
})
