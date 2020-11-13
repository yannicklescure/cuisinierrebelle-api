import Vue from 'vue'
import axios from 'axios'
import * as api from '../api'
import jwt from 'jsonwebtoken'

const fetchStore = ({ commit, dispatch, state }, {}) => {
  console.log('fetch state data')
  return api.fetchState({ commit, dispatch, state }, {})
    .then(response => {
      console.log(response.data)
      commit("SET_DATA", response.data)
      // localStorage.setItem('cuisinier_rebelle', JSON.stringify(response.data))
      // console.log(JSON.parse(localStorage.getItem('cuisinier_rebelle')))
      return response.data
    })
}

export default {

  BOOKMARK: (context, payload) => {
    // console.log(payload)
    return api.bookmark(context, payload)
      .then(response => {
        console.log(`response.status ${response.status}`)
        if (response.status === 200) context.commit("BOOKMARK", payload)
        return response
      })
      .catch(error => {
        // console.log(error)
        return error
      })
  },

  UNBOOKMARK: (context, payload) => {
    // console.log(payload)
        return api.unbookmark(context, payload)
      .then(response => {
        console.log(`response.status ${response.status}`)
        if (response.status === 204) context.commit("UNBOOKMARK", payload)
        return response
      })
      .catch(error => {
        // console.log(error)
        return error
      })
  },

  LIKE: (context, payload) => {
    // console.log(payload)
    return api.like(context, payload)
      .then(response => {
        console.log(`response.status ${response.status}`)
        if (response.status === 200) context.commit("LIKE", payload)
        return response
      })
      .catch(error => {
        // console.log(error)
        return error
      })
  },

  UNLIKE: (context, payload) => {
    // console.log(payload)
        return api.unlike(context, payload)
      .then(response => {
        console.log(`response.status ${response.status}`)
        if (response.status === 204) context.commit("UNLIKE", payload)
        return response
      })
      .catch(error => {
        // console.log(error)
        return error
      })
  },

  IS_AUTHENTICATED: (context, {}) => {
    console.log(context)
    return api.isAuthenticated(context, {})
      .then(async response => {
        console.log(response)
        await context.commit("IS_AUTHENTICATED", response.data)
        return response.data
      })
    // const vueStore = JSON.parse(localStorage.getItem('cuisinier_rebelle'))
    // if (vueStore) {
    //   console.log(vueStore)
    //   // context.commit("IS_AUTHENTICATED", vueStore.data)
    //   context.commit("SET_DATA", vueStore)
    //   return vueStore.data.isAuthenticated
    // } else return false
  },

  SET_STORE: (context, {}) => {
    const vueStore = JSON.parse(localStorage.getItem('cuisinier_rebelle'))
    if (vueStore) {
      if (vueStore.timestamp) return fetchStore(context, {})
      if (vueStore.data.user.email != null || (new Date().getTime() - vueStore.data.lastUpdated < 1000 * 60 * 3)) {
        console.log('vueStore')
        console.log(vueStore)
        // if ( vueStore.data.user === null || new Date().getTime() - vueStore.lastUpdated > 1000 * 60 * 3 ) {
        //   console.log('fetching server, refresh vueStore')
        //   return fetchStore(context, {})
        // } else {
          console.log('loading vueStore...')
          // console.log(vueStore)
          context.commit("SET_DATA", vueStore)
          return vueStore
        // }
      }
    } else {
      console.log('fetching server, initiate vueStore')
      return fetchStore(context, {})
    }
  },

  RECIPE_LOG: (context, payload) => {
    console.log(context.state.data.user)
    return api.recipeLog(context, payload)
      .then(response => {
        if (response.status === 200) context.commit("RECIPE_LOG", { data: payload, views: response.data.views })
        return response
      })
      .catch(error => {
        // console.log(error)
        return error
      })
  },

  LOG_IN: (context, user) => {
    console.log(context.state.data)
    return api.login(context, user)
      .then(response => {
        const token = response.headers.authorization.split('Bearer ')[1]
        console.log(token)
        console.log(jwt.decode(token))
        if (response.status === 200) context.commit("LOG_IN", response)
        return response
      })
      .catch(error => {
        // console.log(error)
        return error
      })
  },

  LOG_OUT: (context, {}) => {
    console.log(context.state.data)
    return api.logout(context, context.state.data.user.auth)
      .then(response => {
        console.log(response)
        if (response.status === 204) context.commit("LOG_OUT", {})
        return response
      })
  },

  NAVBAR_HEIGHT: (context, navbarHeight) => {
    context.commit("NAVBAR_HEIGHT", navbarHeight)
    // localStorage.setItem('cuisinier_rebelle', JSON.stringify(context.state.data))
  },

  // // FETCH_PAGES: (context, { id }) => {
  // //   const vueStore = JSON.parse(localStorage.getItem('vueStore'))
  // //   // console.log(vueStore)
  // //   if (vueStore) {
  // //     console.log('vueStore')
  // //     if ( new Date().getTime() - vueStore.lastUpdated > 1000 * 60 * 3 ) {
  // //       console.log('fetching server, refresh vueStore')
  // //       return createVueStorePage(context, { id })
  // //     } else {
  // //       console.log('loading vueStore')
  // //       context.commit("SET_PAGES", vueStore.data)
  // //       return vueStore
  // //     }
  // //   } else {
  // //     console.log('fetching server, initiate vueStore')
  // //     return createVueStorePage(context, { id })
  // //   }
  // // },

  // SEARCH_QUERY: (context, { query }) => {
  //   console.log(query)
  //   console.log('fetch search query')
  //   return context.dispatch('SET_STORE', {})
  //     .then(() => {
  //       return fetchSearchQuery(context, { query })
  //         .then(response => {
  //          console.log(response.data)
  //          context.commit("SET_SEARCH_POSTS", response.data.posts)
  //          // context.dispatch('FETCH_ITEMS', {})
  //          return response
  //         })
  //     })
  // },

  // FETCH_USER_POSTS: (context, { user }) => {
  //   console.log(user)
  //   console.log('fetch posts')
  //   return context.dispatch('SET_STORE', {})
  //     .then(() => {
  //       return fetchUserPosts(context, { user })
  //         .then(response => {
  //          console.log(response.data)
  //          context.commit("SET_USER_POSTS", response.data)
  //          // context.dispatch('FETCH_ITEMS', {})
  //          return response
  //         })
  //     })
  // },

  // ADD_NEW_COMMENT: (context, { ancestry, post }) => {
  //   return addNewComment(context, { ancestry, post })
  //     .then(response => {
  //       console.log(response.data)
  //       context.commit("SET_NEW_COMMENT", response.data)
  //       return response.data
  //     })
  //     .finally(result => {
  //       localStorage.setItem('vueStore', JSON.stringify(context.state))
  //       return result
  //     })
  // },

  // ADD_NEW_POST: (context, { post }) => {
  //   return addNewPost(context, { post })
  //     .then(response => {
  //       context.commit("SET_NEW_POST", response.data)
  //       return response.data
  //     })
  //     .finally(result => {
  //       localStorage.setItem('vueStore', JSON.stringify(context.state))
  //       return result
  //     })
  // },

  // FORWARD_POST: (context, { post, page }) => {
  //   return forwardPost(context, { post })
  //     .then(response => {
  //       // console.log(response)
  //       context.commit("SET_FORWARD_POST", { payload: response.data, page: page })
  //       return response
  //     })
  //     .finally(result => {
  //       localStorage.setItem('vueStore', JSON.stringify(context.state))
  //       return result
  //     })
  // },

  // EDIT_POST: (context, { post }) => {
  //   return editPost(context, { post })
  //     .then(response => {
  //       // console.log(response)
  //       context.commit("SET_EDIT_POST", response.data)
  //       return response
  //     })
  //     .finally(result => {
  //       localStorage.setItem('vueStore', JSON.stringify(context.state))
  //       return result
  //     })
  // },

  // DELETE_ITEM: (context, { id }) => {
  //   console.log(id)
  //   return deletePost(context, { id })
  //     .then(response => {
  //       console.log(response.data)
  //       context.commit("DELETE_POST", response.data)
  //       return response
  //     })
  //     .finally(result => {
  //       localStorage.setItem('vueStore', JSON.stringify(context.state))
  //       return result
  //     })
  // },

  // DELETE_COMMENT: (context, { post_id, comment_id }) => {
  //   console.log({ post_id, comment_id })
  //   return deleteComment(context, { id: comment_id })
  //     .then(response => {
  //       context.commit("REMOVE_COMMENT", { post_id, comment_id })
  //       return response
  //     })
  //     .finally(result => {
  //       localStorage.setItem('vueStore', JSON.stringify(context.state))
  //       return result
  //     })
  // },

  // PIN_POST: (context, { id }) => {
  //   console.log({ id })
  //   return pin(context, { id: id })
  //     .then(response => {
  //       context.commit("SET_PINNED_POST", response.data)
  //       console.log(response)
  //       return response
  //     })
  //     .finally(result => {
  //       localStorage.setItem('vueStore', JSON.stringify(context.state))
  //       return result
  //     })
  // },

  // LIKED_POST: (context, { id }) => {
  //   console.log(id)
  //   return liked(context, { id })
  //     .then(response => {
  //       if (context.state.data.userShow.posts.length > 0) {
  //         context.commit("SET_LIKED_POST_ALT", {
  //           id: id,
  //           status: response.status
  //         })
  //       } else {
  //         context.commit("SET_LIKED_POST", {
  //           id: id,
  //           status: response.status
  //         })
  //       }
  //       return response
  //     })
  //     .finally(result => {
  //       localStorage.setItem('vueStore', JSON.stringify(context.state))
  //       return result
  //     })
  // },

  // FOLLOW_USER: (context, { id, type }) => {
  //   console.log(id)
  //   return follow(context, { id, type })
  //     .then(response => {
  //       // if (context.state.data.userShow.posts.length > 0) {
  //         context.commit("SET_FOLLOWING", {
  //           id: id,
  //           data: response.data,
  //           type: type,
  //           status: response.status
  //         })
  //       // } else {
  //       //   context.commit("SET_LIKED_POST", {
  //       //     id: id,
  //       //     status: response.status
  //       //   })
  //       // }
  //       return response
  //     })
  //     .finally(result => {
  //       localStorage.setItem('vueStore', JSON.stringify(context.state))
  //       return result
  //     })
  // },

  // LOG_OUT: (context, {}) => {
  //   context.commit("SET_LOG_OUT", {})
  //   .then(() => {
  //     // localStorage.removeItem('vueStore');
  //     localStorage.setItem('vueStore', JSON.stringify(context.state))
  //   })
  // }
}